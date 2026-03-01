terraform {
  # Backend local par défaut
  # Décommentez et adaptez si vous utilisez un backend distant

  # backend "s3" {
  #   bucket = "terraform-state"
  #   key    = "flux/homelab/terraform.tfstate"
  #   region = "eu-west-1"
  # }

  # backend "azurerm" {
  #   resource_group_name  = "terraform-state"
  #   storage_account_name = "tfstate"
  #   container_name       = "tfstate"
  #   key                  = "flux/homelab/terraform.tfstate"
  # }
}
