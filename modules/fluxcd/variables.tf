variable "github_token" {
  description = "GitHub Personal Access Token pour l'authentification"
  sensitive   = true
  type        = string
}

variable "github_owner" {
  description = "Propriétaire du repository GitHub (utilisateur ou organisation)"
  type        = string
}

variable "github_repository" {
  description = "Nom du repository GitHub"
  type        = string
}

variable "github_branch" {
  description = "Branche Git à utiliser"
  type        = string
  default     = "main"
}

variable "flux_bootstrap_git_path" {
  description = "Chemin d'initialisation du projet GitOps dans le repository"
  type        = string
}

variable "flux_kubernetes_config_path" {
  description = "Chemin vers le fichier kubeconfig du cluster"
  type        = string
}

variable "flux_kubernetes_context" {
  description = "Contexte Kubernetes à utiliser"
  type        = string
  default     = "default"
}
