resource "azurerm_resource_group" "rg_github_membership" {
  name     = "github-membership-management"
  location = "Uk South"
}

resource "azurerm_automation_account" "github_membership_automation" {
  name                = "github-membership-automation"
  location            = azurerm_resource_group.rg_github_membership.location
  resource_group_name = azurerm_resource_group.rg_github_membership.name

  sku_name = "Basic"
}

resource "azurerm_automation_runbook" "github_membership_runbook" {
  name                    = var.runbook_name
  location                = azurerm_resource_group.rg_github_membership.location
  resource_group_name     = azurerm_resource_group.rg_github_membership.name
  automation_account_name = azurerm_automation_account.github_membership_automation.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Runbook to recieve notifications when accounts are disabled in AAD"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/hmcts/azure-automation-runbooks/master/runbooks/Get-AzureVMTutorial.ps1"
  }
}