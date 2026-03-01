# Infra - Provisionnement des VMs Rancher sur Proxmox

Module Terraform pour provisionner les machines virtuelles du cluster Rancher (plan de contrôle) sur un hyperviseur Proxmox VE.

## Vue d'ensemble

Ce module effectue deux opérations :

1. **Création du template Rocky 9** : Exécute un script shell sur le serveur Proxmox pour créer le template de base (VM ID 9100)
2. **Provisionnement des VMs** : Clone le template pour créer les 3 nœuds du cluster Rancher

### VMs créées

| VM | ID | IP | CPU | RAM |
|----|----|----|-----|-----|
| `rancher-1` | 110 | 192.168.1.110 | 2 cores | 8 GB |
| `rancher-2` | 111 | 192.168.1.111 | 2 cores | 8 GB |
| `rancher-3` | 112 | 192.168.1.112 | 2 cores | 8 GB |

## Structure

```
infra/
├── main.tf                    # Ressources Terraform (template + VMs)
├── providers.tf               # Provider Proxmox (bpg/proxmox)
├── variables.tf               # Déclaration des variables
├── outputs.tf                 # Outputs (noms et IDs des VMs)
├── terraform.tfvars           # Valeurs des variables
├── credentials.auto.tfvars    # Credentials Proxmox (ignoré par Git)
└── create-rocky9-template.sh  # Script de création du template
```

## Prérequis

- Terraform >= 1.2.0
- Accès SSH root au serveur Proxmox
- Proxmox VE avec accès API

## Configuration

### 1. Credentials Proxmox

Créer un fichier `credentials.auto.tfvars` :

```hcl
proxmox_password = "votre_mot_de_passe_proxmox"
```

> Ce fichier est ignoré par Git

### 2. Variables principales

Éditer `terraform.tfvars` selon votre environnement :

```hcl
proxmox_host      = "192.168.1.100"
proxmox_node      = "devsecops-dojo"
vm_id_start       = 110
network_bridge    = "vmbr0"
ip_address_base   = "192.168.1"
ip_start          = 110
gateway           = "192.168.1.1"
nameserver        = "192.168.1.1"
ssh_public_key    = "ssh-rsa ..."
rancher_cpu_cores = 2
rancher_memory    = 8192              # En MB
```

## Déploiement

```bash
cd modules/infra

# Initialiser Terraform
terraform init

# Vérifier le plan
terraform plan

# Appliquer
terraform apply
```

## Variables

| Variable | Description | Défaut |
|----------|-------------|--------|
| `proxmox_host` | IP du serveur Proxmox | `192.168.1.100` |
| `proxmox_password` | Mot de passe root Proxmox (sensitive) | - |
| `proxmox_node` | Nom du nœud Proxmox | - |
| `network_bridge` | Bridge réseau Proxmox | - |
| `vm_id_start` | ID de la première VM | - |
| `ip_address_base` | Trois premiers octets de l'IP | - |
| `ip_start` | Dernier octet de la première IP | - |
| `gateway` | Passerelle réseau | - |
| `nameserver` | Serveur DNS | - |
| `ssh_public_key` | Clé SSH publique pour root | - |
| `rancher_cpu_cores` | Nombre de vCPUs par VM | - |
| `rancher_memory` | RAM par VM (MB) | - |

## Outputs

| Output | Description |
|--------|-------------|
| `vm_names` | Liste des noms des VMs créées |
| `vm_ids` | Liste des IDs Proxmox des VMs |

## Ordre de déploiement

Ce module est la **première étape** du déploiement. L'ordre global est :

```
1. infra/    → Provisionnement des VMs sur Proxmox
2. rke2/     → Installation de RKE2 et Rancher via Ansible
3. fluxcd/   → Bootstrap de FluxCD sur le cluster
```

## Destruction

```bash
terraform destroy
```

> Cela supprimera les 3 VMs Rancher dans Proxmox. Le template Rocky 9 (VM 9100) ne sera pas supprimé car il est géré par un `null_resource`.
