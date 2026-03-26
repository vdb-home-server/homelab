# Kubernetes

K3s is a lightweight kubernetes distro/flavour we use for the services we want in high availability (HA). This is so in case our home node dies or goes for some reason or another some services have the least possible downtime.

## Naming

- Cluster: all the machines on which this kubernetes instance runs
- Node: one of the machines (physical or vm) in this cluster
- Pod: one container that is running
- Deployment: what we write (what image, how many replicas), creates pods, replaces dead pods, ...
- ReplicaSet: ensures the number of pods are running
- Service: pods come and go, so do their ip's. Services have stable ip's and load balances between the pods
- Ingress (http routing): proxy
- ConfigMap: env vars, non-secret config
- Secret: tokens, passwords, certs, ...
- PersistentVolume (PV): actual storage
- PersistentVolumeClaim (PVC): request that storage (we mostly create PVC's and let kubernetes handle the rest)

## Setup

To install k3s you first make a config file and than simply run the installer script.

### The config file

The config file should be stored in `/etc/rancher/k3s/config.yaml`.
You can easily make this with the following command:

```bash
sudo mkdir -p /etc/rancher/k3s
sudo nano /etc/rancher/k3s/config.yaml
```

#### The first node

This config file is only for the first node, so the cluster is properly made and k3s is setup. After that this node behaves exactly the same as any other node added to the cluster.

```yaml
cluster-init: true
node-name: <NODE NAME>
node-ip: <NODE IP>
advertise-address: <NODE IP>

tls-san:
  - cluster.vdbhome.ovh
  - <NODE DNS>
```

#### Other nodes

To add other nodes you will need to get the cluster token, on a node that already is in the cluster run:

```bash
sudo cat /var/lib/rancher/k3s/server/token
```

and replace `<TOKEN>` with it in the config file.

```yaml
server: https://cluster.vdbhome.ovh:6443
token: <TOKEN>

node-name: <NODE NAME>
node-ip: <NODE IP>
advertise-address: <NODE IP>

tls-san:
  - cluster.vdbhome.ovh
  - <NODE DNS>
```

> [!IMPORTANT]
> For both the above options (the first node and other nodes) the only reason we need to specify `node-ip` and `advertise-address` is because we are NOT using a LAN connection and running it via the netbird overlay network. By default (when we don't specify both options) it uses the LAN address and the cluster won't be accessible via netbird.

### The installation script

Simply run the following command: it can have arguments but we specify everything in the config file.

```bash
curl -sfL https://get.k3s.io | sh -
```

## DNS failover

In the `HA/k3s` directory there is a `failover.sh` script. This makes sure the DNS record of `cluster.vdbhome.ovh` stays alive. In the `NODES` constant, you put the DNS names of the individual nodes. The script checks whether or not the `cluster.vdbhome.ovh` is healthy, if not it changes the record to the first healthy node in the `NODES` constant. When the record isn't to the first node in the variable, it keeps checking that node and when it becomes healthy again it changes back to the first node in the variable (the main node).
