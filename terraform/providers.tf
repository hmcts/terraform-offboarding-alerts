terraform {
  required_version = ">= 0.14.4"
  backend "azurerm" {
    subscription_id      = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
    resource_group_name  = "core-infra-intsvc-rg"
    storage_account_name = "cftptlintsvc"
    container_name       = "tfstate"
    key                  = "terraform-github-management.tfstate"
  }
}
provider "azurerm" {
  features {}
}
