resource "azurerm_template_deployment" "github_management_template" {
  name                = "${var.runbook_name}_webhook"
  resource_group_name = azurerm_resource_group.rg_github_membership.name
  deployment_mode     = "Incremental"
  template_body       = <<DEPLOY
  {
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
        "name": "${azurerm_automation_account.github_membership_automation.name}/webhook",
        "type": "Microsoft.Automation/automationAccounts/webhooks",
        "apiVersion": "2015-10-31",
        "properties": {
            "isEnabled": true,
            "uri": "${local.webhook_uri}",
            "expiryTime": "2030-01-01T00:00:00.000+00:00",
            "parameters": {},
            "runbook": {
            "name": "${azurerm_automation_runbook.github_membership_runbook.name}"
            }
        }
        }
    ]
  }
  DEPLOY
}