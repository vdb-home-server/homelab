# Nextcloud
## Postgres
Make sure the following environment variables are the same as in the postgres instance.
```env
NEXTCLOUD_DB = 
NEXTCLOUD_USER = 
NEXTCLOUD_PASSWORD = 
```

## OIDC
This connects nextcloud to authentik. In the authentik admin interface, create an ```OAuth2/OpenID``` provider. Copy and paste the client id and secret in the .env file. After that go back to the authentik admin interface and create an application. Fill in the name and slug and click create. Fill in the slug in the .env file too. 

```env
OIDC_LOGIN_CLIENT_SECRET = 
OIDC_LOGIN_CLIENT_ID = 
OIDC_LOGIN_PROVIDER_SLUG = 
```