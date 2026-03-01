# FluxCD - Bootstrap GitOps sur le cluster Rancher

Module Terraform pour bootstrapper FluxCD sur le cluster Kubernetes Rancher avec GitHub comme source GitOps.

## Structure

```
fluxcd/
├── main.tf              # Bootstrap FluxCD sur le cluster
├── providers.tf         # Providers Flux et GitHub
├── backend.tf           # Configuration du backend Terraform
├── variables.tf         # Déclaration des variables
├── terraform.tfvars     # Valeurs des variables
├── secrets.auto.tfvars  # GitHub Token (ignoré par Git)
└── README.md
```

## Prérequis

- Terraform ~> 1.13
- Cluster Kubernetes opérationnel (kubeconfig disponible)
- GitHub Personal Access Token (classic) avec scope `repo`

## Configuration

### 1. Créer un GitHub Token

1. Aller sur https://github.com/settings/tokens
2. **Generate new token (classic)**
3. Cocher le scope `repo`
4. Copier le token

### 2. Configurer le token

Créer un fichier `secrets.auto.tfvars` :

```hcl
github_token = "ghp_votre_token"
```

> Ce fichier est ignoré par Git

### 3. Kubeconfig

Le kubeconfig du cluster Rancher est généré par le module `rke2` et accessible à :

```
../rke2/kubeconfig.yaml
```

## Déploiement

```bash
cd modules/fluxcd
terraform init
terraform plan
terraform apply
```

## Variables

| Variable | Description | Défaut |
|----------|-------------|--------|
| `github_token` | GitHub PAT (sensitive) | - |
| `github_owner` | Propriétaire du repo GitHub | - |
| `github_repository` | Nom du repository GitOps | - |
| `github_branch` | Branche Git | `main` |
| `flux_bootstrap_git_path` | Chemin dans le repo pour ce cluster | - |
| `flux_kubernetes_config_path` | Chemin vers le kubeconfig | - |
| `flux_kubernetes_context` | Contexte Kubernetes à utiliser | `default` |

**Valeurs configurées** (voir `terraform.tfvars`) :

| Variable | Valeur |
|----------|--------|
| `github_owner` | `ngatcheu` |
| `github_repository` | `datacenter-gitops-fluxcd` |
| `flux_bootstrap_git_path` | `clusters/cluster-rancher` |
| `flux_kubernetes_config_path` | `../rke2/kubeconfig.yaml` |

## Vérification

Après le déploiement :

```bash
export KUBECONFIG=../rke2/kubeconfig.yaml

# Vérifier les pods Flux
kubectl get pods -n flux-system

# Vérifier le statut
flux check

# Voir les sources Git
flux get sources git

# Voir les Kustomizations
flux get kustomizations
```

## Destruction

```bash
terraform destroy
```

> Cela supprimera les composants Flux du cluster mais pas les ressources déployées par Flux.
