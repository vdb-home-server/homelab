# Ansible playbooks

Ansible is designed to automate things inside a shell. First is a quick overview and after that there is a more detailed explanation for every playbook.

## Introduction

### Installation

To run ansible playbooks, the ansible cli will need to be installed. With ubuntu: 

```bash
apt install ansible
```

On the connected system/server the only thing that should be installed is python3, this comes packed with most linux distro's, including `ubuntu`.

### Overview of a playbook

#### File structure

For each playbook there are a couple of files:

```md
├── ansible.cfg
├── ansible_vault_pass
├── group_vars
│   └── all
│       └── vault.yaml
├── inventory.ini
├── playbook.yaml
├── ssh_private
└── ssh_public
```

#### ansible.cfg

Here are the basic configurations stored for ansible, where the password and inventory files are stored.

#### ansible_vault_pass

The `ansible_vault_pass` is not pushed to github, so this needs to be create manually. Here you simply paste the password of the vault on the first line.

#### group_vars/all/vault.yaml

This is the vault where secrets are stored. These are encrypted with `AES256` and thus safe to push to github without the password.

#### inventory.ini

More playbooks specific configs are stored here, things like which servers to connect to and which users to login with.

#### playbook.yaml

This is the playbook itself. It describes what should happen on the connected system.

#### ssh_private

This is the private ssh key. This is also not uploaded to github.

#### ssh_public

This is the public ssh key.

### How to run

Make sure you have the ansible cli tool installed on your working device. To run a ansible playbook make sure you first have created the `ansible_vault_pass` and `ssh_private`, otherwise the playbook wont be able to run.

If those files are there simply run 

```bash
ansible-playbook path/to/playbook.yaml
```

## Overview of the playbooks

### Setup

This playbooks sets up a ubuntu server. It updates the packages, installs curl and git, installs netbird and sets up netbird with the `lxcs` setup key.