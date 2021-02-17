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
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  features {}
}

provider "azurerm" {
  alias = "arm_template"
  features {
    template_deployment {
      delete_nested_items_during_deletion = false
    }
  }
}

provider "azuread" {
}

provider "azurerm" {
  alias           = "keyvault"
  subscription_id = "00b9a00a-20eb-4173-b7b6-468e00836a33"
  features {}
}