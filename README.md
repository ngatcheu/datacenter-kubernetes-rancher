# datacenter-kubernetes-rancher

Infrastructure as Code pour déployer et gérer le cluster Kubernetes RKE2 dédié à **Rancher** (plan de contrôle/gestion).

## Architecture

```
┌─────────────────────────────────────────────┐
│      VIP Kubernetes API (Keepalived)        │
│           192.168.1.130:6443                │
└─────────────────────────────────────────────┘
           │          │          │
    ┌──────┴────┬─────┴────┬────┴──────┐
    │ Rancher-1 │Rancher-2 │ Rancher-3 │
    │192.168.1. │192.168.1.│192.168.1. │
    │   110     │   111    │    112    │
    └───────────┴──────────┴───────────┘
```

## Modules

| Module | Outil | Description |
|--------|-------|-------------|
| [`modules/infra/`](modules/infra/README.md) | Terraform | Provisionnement des 3 VMs sur Proxmox |
| [`modules/rke2/`](modules/rke2/README.md) | Ansible | Installation de RKE2 + Rancher |
| [`modules/fluxcd/`](modules/fluxcd/README.md) | Terraform | Bootstrap FluxCD (GitOps) |

## Prérequis

- `make`
- `terraform` >= 1.2.0
- `ansible` >= 2.10
- Accès SSH au serveur Proxmox et aux VMs

## Démarrage rapide

### 1. Configurer l'environnement

```bash
cp .env.example .env   # puis éditer .env
```

### 2. Voir les cibles disponibles

```bash
make help
```

### 3. Déploiement complet

```bash
# Provisionner les VMs sur Proxmox
make infra-init
make infra-apply

# Installer les collections Ansible
make rke2-deps

# Déployer RKE2 + Rancher
make rke2-install

# Bootstrapper FluxCD
make fluxcd-init
make fluxcd-apply
```

## Référence Makefile

### Infra (Terraform / Proxmox)

```bash
make infra-init       # terraform init
make infra-plan       # terraform plan
make infra-apply      # terraform apply
make infra-destroy    # terraform destroy
```

### RKE2 (Ansible)

```bash
make rke2-deps        # Installer les collections Ansible
make rke2-install     # Installer le cluster (ENV=production par défaut)
make rke2-install ENV=staging
make rke2-uninstall   # Désinstaller le cluster
make rke2-update      # Mettre à jour les VMs
make rke2-reboot      # Redémarrer les nœuds
make rke2-maintenance # Tâches de maintenance
```

### FluxCD (Terraform / GitOps)

```bash
make fluxcd-init      # terraform init
make fluxcd-plan      # terraform plan
make fluxcd-apply     # terraform apply
make fluxcd-destroy   # terraform destroy
```

## Configuration

Les variables sont définies dans `.env` à la racine :

```bash
ENV=production        # staging | production
PROXMOX_HOST=192.168.1.100
PROXMOX_NODE=devsecops-dojo
```

L'environnement peut être surchargé à la volée :

```bash
make rke2-install ENV=staging
```

## Structure

```
datacenter-kubernetes-rancher/
├── Makefile
├── .env                  # Variables locales (ignoré par Git)
├── .gitignore
├── modules/
│   ├── infra/            # Terraform Proxmox
│   ├── rke2/             # Ansible RKE2 + Rancher
│   └── fluxcd/           # Terraform FluxCD
└── README.md
```
