# Welcome
This repo exists solely to make the setup and versioning of our homelab easier. At the moment there are just the config files for the high availability cluster. In the near future I will add the rest of the config files. After everything is setup I also will look into adding workflows and ansible playbooks to ease the deploy process even more.

# ToDo's
- [ ] Add compose files
  - [x] Add HA compose files
    - [x] Add authentik
    - [x] Add uptime kuma
    - [x] Add gotify
    - [x] Add postgres
    - [x] Add traefik
    - [x] Add vaultwarden
  - [ ] Add prod compose files
    - [x] Add traefik
    - [x] Add authentik outpost
    - [x] Add postgress
    - [x] Add nextcloud
    - [x] Add *arr stack
      - [x] Add prowlarr
      - [x] Add radarr
      - [x] Add sonarr
      - [x] Add bookshelf (readarr fork, check if it stays active)
      - [x] Add jellyseer/overseer (they are currently merging)
      - [x] Add LazyLibrarian
      - [x] Add gluetun
      - [x] Add NZBget
      - [x] Add qBitTorrent
    - [x] Add Jellyfin
    - [x] Add Immich
    - [ ] Add backvault
    - [ ] Add restic
- [ ] Add further CI/CD
  - [ ] Add ansible playbooks
  - [ ] Research how to automate it without security risks
