# Hexlet tests and linter status:
[![Actions Status](https://github.com/AlekseyKowalsky/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/AlekseyKowalsky/devops-for-programmers-project-77/actions)

# The application web address:
https://alekspaces.com

# Getting start
## Requirements:
- OS: Linux
- Installed tools: Make, Ansible, Terraform

## Preparing to work on infrastructure:
1. Actualize terraform secrets in the [terraform/secrets](terraform%2Fsecrets) directory:
- place there `.infra.vault_pass` text file with the vault password for terraform secrets
- use make commands to encrypt/decrypt vault secrets in order to change them:
```bash
 make infra-vault-encrypt
```
```bash
 make infra-vault-decrypt
```
2. Initiate terraform by the command:
```bash
make infra-init
```
3. In order to get access to terraform remote backend, login into Terraform Cloud [in accordance with the docs](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login).

## Working on infrastructure:
1. Figure it out if there are changes of infrastructure by command:
```bash
make infra-plan
```
2. Create infrastructure and/or apply changes by command:
```bash
make infra-apply
```
3. Destroy infrastructure by command:
> THINK, IT WILL DESTROY ALL THE INFRASTRUCTURE
```bash
make infra-destroy
```

## Setup and deploy the application:
> After the infrastructure was raised, it is allowed to setup servers and deploy the app on them
1. Actualize ansible secrets in the [ansible/group_vars/all](ansible%2Fgroup_vars%2Fall)[ansible/group_vars/all](ansible%2Fgroup_vars) directory:
- place there `.vault_pass` text file with the vault password for ansible secrets
- check that [server-ips.yaml](ansible%2Fgroup_vars%2Fall%2Fserver-ips.yaml) includes actual IP addresses of servers. However, default behavior is that terraform writes them by itself while creating machines.
- use make commands to encrypt/decrypt vault secrets in order to change them:
```bash
make ansible-encrypt-vault
```
```bash
make ansible-decrypt-vault
```

2. Check availability of machines:
```bash
make ansible-check-webservers
```
3. Install needed requirement:
```bash
make ansible-install-requirements
```
4. Prepare webservers before running the app:
```bash
make ansible-setup-webservers
```
5. Deploy and run the application on webservers :
```bash
make ansible-deploy-webservers
```

## Quick creation of the website from scratch:
In order to raise the website quickly, just after authorizing terraform and setting up variables and secrets, use the command:
```bash
make raise-from-scratch
```