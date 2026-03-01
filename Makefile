-include .env
export

INFRA_DIR  := modules/infra
RKE2_DIR   := modules/rke2
FLUXCD_DIR := modules/fluxcd

ENV ?= production

.PHONY: help \
        infra-init infra-plan infra-apply infra-destroy \
        rke2-deps rke2-install rke2-uninstall rke2-update rke2-reboot rke2-maintenance \
        fluxcd-init fluxcd-plan fluxcd-apply fluxcd-destroy

help: ## Afficher l'aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ==============================================================================
# INFRA - Terraform (Proxmox)
# ==============================================================================

infra-init: ## Initialiser Terraform (infra)
	cd $(INFRA_DIR) && terraform init

infra-plan: ## Planifier le provisionnement des VMs
	cd $(INFRA_DIR) && terraform plan

infra-apply: ## Provisionner les VMs Rancher sur Proxmox
	cd $(INFRA_DIR) && terraform apply

infra-destroy: ## Détruire les VMs Rancher
	cd $(INFRA_DIR) && terraform destroy

# ==============================================================================
# RKE2 - Ansible (ENV=staging|production)
# ==============================================================================

rke2-deps: ## Installer les collections Ansible requises
	cd $(RKE2_DIR) && ansible-galaxy collection install -r collections/requirements.yml

rke2-install: ## Installer le cluster RKE2 (ENV=staging|production)
	cd $(RKE2_DIR) && ansible-playbook -i inventory-$(ENV).yml install_rke2.yml -e "ENVIRONNEMENT=$(ENV)"

rke2-uninstall: ## Désinstaller le cluster RKE2 (ENV=staging|production)
	cd $(RKE2_DIR) && ansible-playbook -i inventory-$(ENV).yml uninstall_rke2.yml -e "confirm_uninstall=yes"

rke2-update: ## Mettre à jour les VMs (ENV=staging|production)
	cd $(RKE2_DIR) && ansible-playbook -i inventory-$(ENV).yml update-vms.yml

rke2-reboot: ## Redémarrer les nœuds (ENV=staging|production)
	cd $(RKE2_DIR) && ansible-playbook -i inventory-$(ENV).yml reboot.yml

rke2-maintenance: ## Tâches de maintenance (ENV=staging|production)
	cd $(RKE2_DIR) && ansible-playbook -i inventory-$(ENV).yml node-maintenance-tasks.yml

# ==============================================================================
# FLUXCD - Terraform (GitOps)
# ==============================================================================

fluxcd-init: ## Initialiser Terraform (fluxcd)
	cd $(FLUXCD_DIR) && terraform init

fluxcd-plan: ## Planifier le bootstrap FluxCD
	cd $(FLUXCD_DIR) && terraform plan

fluxcd-apply: ## Bootstrapper FluxCD sur le cluster
	cd $(FLUXCD_DIR) && terraform apply

fluxcd-destroy: ## Supprimer FluxCD du cluster
	cd $(FLUXCD_DIR) && terraform destroy
