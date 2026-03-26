# Traefik

## Exposing an app

To expose app via traefik add following labels to said app's docker compose file:

```yaml
labels:
  - traefik.enable=true # enables traefik reverse proxy (need to add this explicitly because in the traefik config file the exposedByDefault flag is set to false)

  # only to open it via http
  - traefik.http.routers.<router name http>.rule=Host("<url to the app>")
  - traefik.http.routers.<router name http>.entrypoints=web

  # defaults to port 80, so only change when the port the app is exposed in is not port 80
  - traefik.http.routers.<router name http>.service=<service name http>
  - traefik.http.services.<service name http>.loadbalancer.server.port=<port>
```

`<router name http>` can be set to whatever you like, I will use naming convention `<app name>-http` eg `traefik-http`.
`<url to the app>` should be the full url to the app, including the lxc it's running in, so `<app name>.<prod, test, ha>.vdbhome.ovh` eg `traefik.prod.vdbhome.ovh`.
`<service name http>` should be the name of the service, this can be anything. Our convention is `<app name>-http-svc`, eg `traefik-http-svc`.

## Best practices

Add the following labels just to be sure traefik doesn't fuck up

```yaml
labels:
  - traefik.docker.network=frontend # This makes sure traefik uses the right docker network
  - traefik.http.routers.<router name>.service=<service name http>
  - traefik.http.services.<service name>.loadbalancer.server.port=<port> # even if the port is 80
```

## When to restart

The traefik container monitors the docker socket (see volume `/var/run/docker.sock:/var/run/docker.sock` and the docker provider in `./config/traefik.yaml`), so when a new app is launched with the correct labels the traefik container doesn't need to be restarted. When the labels of an app are changed, that specific app needs to be restarted before it applies.
When editing the static config file (`./config/traefik.yaml`) the traefik container needs to be restarted before changes apply.

## TLS

Traefik supports tls and https encrypted traffic with certificates via letsencrypt. This prevents the "untrusted certificate" warning in browsers. For the cloudflare dns server it needs a environment variable `CF_DNS_API_TOKEN`. To see how to setup this token, [see the cloudflare docs](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/).

### Exposing an app with https

To expose an app via https add following labels:

```yaml
labels:
  # only to open it via https
  - traefik.http.routers.<router name https>.tls=true
  - traefik.http.routers.<router name https>.tls.certresolver=<cert resolver name>
  - traefik.http.routers.<router name https>.rule=Host("<url to the app>")
  - traefik.http.routers.<router name https>.entrypoints=websecure
```

`<router name https>` can be set to whatever you like, I will use naming convention `<app name>-https` eg `traefik-https`.
`<cert resolver name>` should be set to whatever certresolver you want to use that you have specified in the static config file (`./config/traefik.yaml`), in our case it should be set to `cloudflare`.
`<url to the app>` should be the full url to the app, including the lxc it's running in, so `<app name>.<prod, test, ha>.vdbhome.ovh` eg `traefik.prod.vdbhome.ovh`.

### Making a cert resolver

Add the following to the static config file (`./config/traefik.yaml`):

```yaml
certificatesResolvers:
  cloudflare:
    acme:
      email: "<the email of the account>"
      storage: "<cert path>"
      caServer: "https://acme-v02.api.letsencrypt.org/directory"
      keyType: EC256
      dnsChallenge:
        provider: <provider>
        resolvers: # specify dns resolvers because it isn't very stable otherwise
          - "1.1.1.1:53"
          - "8.8.8.8:53"
```

`<the email of the account>` should be the email address of the account for which the API token was created, in our case `woutvandbossche@gmail.com`
`<cert path>` should be the path to the file where the certificates need to be saved. ! This should be in a volume !
`<provider>` should be the dns provider of the domain name, in our case `cloudflare`.
