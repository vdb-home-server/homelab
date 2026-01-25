# Authentik

## Installation
Make sure the ```worker``` component is contected to the ```backend``` network and the ```server``` component is connected to both the ```frontend``` and the ```backend``` networks.
Make sure the ```AUTHENTIK_DB```, the ```AUTHENTIK_USER``` and the ```AUTHENTIK_PASSWORD``` enviroment variables are the same as in the postgres env file.
For the secret key (```AUTHENTIK_SECRET_KEY```) use the ```openssl rand --base64 36``` command.

## Initial setup
The first time you try to log in to authentik you need to use the ```akadmin``` username. Go through the user setup process an login. Click on ```Admin Interface``` and in ```Directory``` > ```Users``` you create a new account and add it to the ```authentik admins``` group. After that you log out of the ```akadmin``` account and login with your personal account and again in ```Admin Interface``` > ```Directory``` > ```Users``` you disable the ```akadmin``` user.

## Creating a user
In ```Admin Interface``` > ```Directory``` > ```Users```, you click create. 
- Username: the username of the account (eg wout)
- Name: the full name of the account (eg Wout Van den Bossche)
- User type: leave default to ```Internal```
- Email: doesn't matter much
- Is active: leave enabled
- Path: leave default to ```users```
- Attributes: give custom attributes, doesn't matter much in our case

After everything is filled in, click ```Create```
If you want to add a password, select the user and click ```Set password```

If you want to add the user to a group click the user, go to ```Groups``` and ```Add to existing group```. Select the ```authentik Admins``` group and click add.

## Connect applications
See [authentik docs](https://integrations.goauthentik.io/applications/)

## Add proxy auth
(See [the offical proxy docs for traefik](https://docs.goauthentik.io/add-secure-apps/providers/proxy/server_traefik/))

Add the following to the traefik static config file (```./config/traefik.yaml```):
```yaml
providers:
    file:
        directory: /etc/traefik/conf/
        watch: true
```
and to ```./config/headers.yaml```:
```yaml
http:
    middlewares:
        authentik:
            forwardAuth:
                address: http://<authentik outpost>:9000/outpost.goauthentik.io/auth/traefik
                trustForwardHeader: true
                authResponseHeaders:
                    - X-authentik-username
                    - X-authentik-groups
                    - X-authentik-entitlements
                    - X-authentik-email
                    - X-authentik-name
                    - X-authentik-uid
                    - X-authentik-jwt
                    - X-authentik-meta-jwks
                    - X-authentik-meta-outpost
                    - X-authentik-meta-provider
                    - X-authentik-meta-app
                    - X-authentik-meta-version
```

Make sure that in the traefik compose file the ```./config/:/etc/traefik/conf/:ro``` volume is added.

Add the folowing label to the compose file of the app you want to put behind the proxy auth:
```yaml
labels:
    - traefik.http.routers.<router name>.middlewares=authentik
```

After that create a proxy provider in the authentik dashboard. Chose ```Forward auth (single application)``` and in the ```external host``` field type the full url of the webserver (eg: https://traefik.ha.vdbhome.ovh) and click finish.
Than create an application in the authentik dashboard.
In ```Outposts``` select the outpost where the app you want to put behind the proxy auth is running, click on edit and add the application you just created.gi