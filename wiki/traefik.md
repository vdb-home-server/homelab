# Traefik

To expose app via traefik add following labels to said app's docker compose file:
```yaml
labels:
    - traefik.enable=true # enables traefik reverse proxy (need to add this explicitly because in the traefik config file the exposedByDefault flag is set to false)
    
    # only to open it via http
    - traefik.http.routers.<router name http>.rule=Host("<url to the app>")
    - traefik.http.routers.<router name http>.entrypoints=web
```

<router name> 