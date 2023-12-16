INFRA_VAULT_PASSWORD_FILE := terraform/.infra.vault_pass
ANSIBLE_VAULT_PASSWORD_FILE := ansible/group_vars/all/.vault_pass

infra-vault-decrypt:
	ansible-vault decrypt terraform/secrets/vault.yaml --output=terraform/secrets/vault.decrypted.yaml --vault-password-file $(INFRA_VAULT_PASSWORD_FILE)

infra-vault-encrypt:
	ansible-vault encrypt terraform/secrets/vault.decrypted.yaml --output=terraform/secrets/vault.yaml --vault-password-file $(INFRA_VAULT_PASSWORD_FILE)

infra-template-tf-vars:
	ansible localhost -m template -a "src=terraform/secrets/tfvars-template.j2 dest=terraform/secrets.auto.tfvars" -e "@terraform/secrets/vault.decrypted.yaml"

infra-generate-tf-vars:
	$(MAKE) infra-vault-decrypt
	$(MAKE) infra-template-tf-vars

infra-init:
	$(MAKE) infra-generate-tf-vars
	terraform -chdir=./terraform init

infra-plan:
	$(MAKE) infra-generate-tf-vars
	terraform -chdir=./terraform plan

infra-apply:
	$(MAKE) infra-generate-tf-vars
	terraform -chdir=./terraform apply

infra-destroy:
	$(MAKE) infra-generate-tf-vars
	terraform -chdir=./terraform destroy

infra-output:
	$(MAKE) infra-generate-tf-vars
	terraform -chdir=./terraform output



ansible-check-webservers:
	ansible all -m ping -i ./ansible/inventory.yml --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

ansible-install-requirements:
	ansible-galaxy install -r ansible/requirements.yml

ansible-setup-webservers:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.yml -t setup --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

ansible-deploy-webservers:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.yml -t deploy --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

ansible-decrypt-vault:
	ansible-vault decrypt ansible/group_vars/all/vault.yml --output=ansible/group_vars/all/vault.decrypted.yml --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

ansible-encrypt-vault:
	ansible-vault encrypt ansible/group_vars/all/vault.decrypted.yml --output=ansible/group_vars/all/vault.yml --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

raise-from-scratch:
	$(MAKE) infra-init
	$(MAKE) infra-apply
	$(MAKE) ansible-install-requirements
	$(MAKE) ansible-setup-webservers
	$(MAKE) ansible-deploy-webservers