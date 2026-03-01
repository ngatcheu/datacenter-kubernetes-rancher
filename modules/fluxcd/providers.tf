terraform {
  required_version = "~> 1.13"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.6.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

provider "flux" {
  kubernetes = {
    config_path    = var.flux_kubernetes_config_path
    config_context = var.flux_kubernetes_context
  }
  git = {
    url    = "https://github.com/${var.github_owner}/${var.github_repository}.git"
    branch = var.github_branch
    http = {
      username = "git"
      password = var.github_token
    }
  }
}
