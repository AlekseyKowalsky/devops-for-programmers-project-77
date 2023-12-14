INFRA_VAULT_PASSWORD_FILE := terraform/.infra.vault_pass

infra-vault-decrypt:
	ansible-vault decrypt terraform/secrets/vault.yaml --output=terraform/secrets/vault.decrypted.yaml --vault-password-file $(INFRA_VAULT_PASSWORD_FILE)

infra-vault-encrypt:
	ansible-vault encrypt terraform/secrets/vault.decrypted.yaml --output=terraform/secrets/vault.yaml --vault-password-file $(INFRA_VAULT_PASSWORD_FILE)

template-tf-vars:
	ansible localhost -m template -a "src=terraform/secrets/tfvars-template.j2 dest=terraform/secrets.auto.tfvars" -e "@terraform/secrets/vault.decrypted.yaml"

generate-tf-vars:
	$(MAKE) infra-vault-decrypt
	$(MAKE) template-tf-vars

infra-init:
	$(MAKE) generate-tf-vars
	terraform -chdir=./terraform init

infra-plan:
	$(MAKE) generate-tf-vars
	terraform -chdir=./terraform plan

infra-apply:
	$(MAKE) generate-tf-vars
	terraform -chdir=./terraform apply

infra-destroy:
	$(MAKE) generate-tf-vars
	terraform -chdir=./terraform destroy

