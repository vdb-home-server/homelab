# This explains what needs to be configured on the host machines
## HA
Manually create 2 docker networks.
```bash
docker network create frontend
docker network create backend
```

## Prod
Manually create 2 docker networks.
```bash
docker network create frontend
docker network create backend
```

## Test
Manually create 2 docker networks.
```bash
docker network create frontend
docker network create backend
```

## Disable builtin-auth
- prowlarr
- sonarr
- bookshelf/readarr
- radarr

## Change auth from built-in to authentik
### In the UI
- jellyseerr

### In the env vars
- nextcloud