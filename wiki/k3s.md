# Kubernetes
K3s is a lightweight kubernetes distro/flavour we use for the services we want in high availability (HA). This is so in case our home node dies or goes for some reason or another some services have the least possible downtime. 

## Naming
- Cluster: all the machines on which this kubernetes instance runs
- Node: one of the machines (physical or vm) in this cluster
- Pod: one container that is running
- Deployment: what we write (what image, how many replicas), creates pods, replaces dead pods, ...
- ReplicaSet: ensures the number of pods are running
- Service: pods come and go, so do their ip's. Services have stable ip's and loadbalances between the pods
- Ingress (http routing): proxy
- ConfigMap: env vars, non-secret config
- Secret: tokens, passwords, certs, ...
- PersistentVolume (PV): actual storage
- PersistentVolumeClaim (PVC): request that storage (we mostly create PVC's and let kubernetes handle the rest)

## Setup
### The first node
On one of the nodes (doesn't matter which one) run the following.
```bash
curl -sfL https://get.k3s.io | sh -s - server \
  --cluster-init \
  --node-ip <NODE1_IP> \
  --advertise-address <NODE1_IP> \
  --tls-san <NODE1_DNS_NAME> \
  --tls-san <K3S_API_DNS_NAME> \
  --write-kubeconfig-mode 644
```
Replace ```<NODE1_IP>``` with the netbird ip address of the current node. ```<NODE1_DNS_NAME>``` and ```<K3S_API_DNS_NAME>``` should be replaced with the dns name of the node and k3s api respectivly (so ```node1.k3s.vdbhome.ovh``` and ```api.k3s.vdbhome.ovh``` in our case.)
After that you get the private cluster token needed to join the cluster with the folowing command:
```bash
cat /var/lib/rancher/k3s/server/node-token
```

### Joining the cluster
On all of the other nodes run the following to join the kubernetes cluster. 
```bash
curl -sfL https://get.k3s.io | sh -s - server \
  --server <K3S_API_DNS_NAME> \
  --token <TOKEN> \
  --node-ip <NODE_IP> \
  --advertise-address <NODE_IP> \
  --tls-san <K3S_API_DNS_NAME>
```
Replace ```<NODE_IP>``` with the ip address of the current node (NOT NODE 1) and ```<K3S_API_DNS_NAME>``` with the dns name of the kubernetes api and ```<TOKEN>``` with the token you got from node 1. 

## Kube-vip
