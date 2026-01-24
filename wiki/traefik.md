# Traefik

## Exposing an app
To expose app via traefik add following labels to said app's docker compose file:
```yaml
labels:
    - traefik.enable=true # enables traefik reverse proxy (need to add this explicitly because in the traefik config file the exposedByDefault flag is set to false)
    
    # only to open it via http
    - traefik.http.routers.<router name http>.rule=Host("<url to the app>")
    - traefik.http.routers.<router name http>.entrypoints=web
```

```<router name http>``` can be set to whatever you like, I will use naming convention ```<app name>-http``` eg ```traefik-https```.
```<url to the app>``` should be the full url to the app, including the lxc it's running in, so ```<app name>.<prod, test, ha>.vdbhome.ovh``` eg ```traefik.prod.vdbhome.ovh```.


## When to restart
The traefik container monitors the docker socket (see volume ```/var/run/docker.sock:/var/run/docker.sock``` and the docker provider in ```./config/traefik.yaml```), so when a new app is launched with the correct labels the traefik container doesn't need to be restarted. When the labels of an app are changed, that specific app needs to be restarted before it applies.
When editing the static config file (```./config/traefik.yaml```) the traefik container needs to be restarted before changes apply.

## TLS
Traefik supports tls and https encrypted traffic with certificates via letsencrypt. This prevents the "untrusted certificate" warning in browsers. For the cloudflare dns server it needs a enviroment variable ```CF_DNS_API_TOKEN```. To see how to setup this token, [see the cloudflare docs](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/).

To expose an app via https add following labels:
```yaml
labels:
    # only to open it via https
    - traefik.http.routers.<router name https>.tls=true
    - traefik.http.routers.<router name https>.tls.certresolver=<cert resolver name>
    - traefik.http.routers.<router name https>.rule=Host("<url to the app>")
    - traefik.http.routers.<router name https>.entrypoints=websecure
```
```<router name https>``` can be set to whatever you like, I will use naming convention ```<app name>-https``` eg ```traefik-https```.
```<cert resolver name>``` should be set to whatever certresolver you want to use that you have specified in the static config file (```./config/traefik.yaml```), in our case it should be set to ```cloudflare```.
```<url to the app>``` should be the full url to the app, including the lxc it's running in, so ```<app name>.<prod, test, ha>.vdbhome.ovh``` eg ```traefik.prod.vdbhome.ovh```.