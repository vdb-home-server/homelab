# Authentik

## Setup
Make sure the ```worker``` component is contected to the ```backend``` network and the ```server``` component is connected to both the ```frontend``` and the ```backend``` networks.
Make sure the ```AUTHENTIK_DB```, the ```AUTHENTIK_USER``` and the ```AUTHENTIK_PASSWORD``` enviroment variables are the same as in the postgres env file.
For the secret key (```AUTHENTIK_SECRET_KEY```) use the ```openssl rand --base64 36``` command.