
resource "null_resource" "generate_uri" {
  triggers = {
      always = timestamp()
  }

  provisioner "local-exec" {
    command = "uri=$(az rest -m post --header 'Accept=application/json' -u 'https://management.azure.com/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.rg_github_membership.name}/providers/Microsoft.Automation/automationAccounts/${azurerm_automation_account.github_membership_automation.name}/webhooks/generateUri?api-version=2015-10-31' -o tsv) && printf \"%s\" $uri > webhookUri.txt"
  }
}

locals {
  webhook_name = "${var.runbook_name}-${random_string.random.result}"
}


resource "random_string" "random" {
  length = 8
  special = false
  keepers = {
    time = timestamp()
  }
}

resource "azurerm_resource_group_template_deployment" "github_management_template" {
  provider = azurerm.test
  name                = "${var.runbook_name}_${random_string.random.result}"
  resource_group_name = azurerm_resource_group.rg_github_membership.name
  deployment_mode     = "Incremental"
  depends_on      = [azurerm_automation_runbook.github_membership_runbook,null_resource.generate_uri]
  template_content    = <<TEMPLATE
  {
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
        "name": "${azurerm_automation_account.github_membership_automation.name}/${local.webhook_name}",
        "type": "Microsoft.Automation/automationAccounts/webhooks",
        "apiVersion": "2015-10-31",
        "properties": {
            "isEnabled": true,
            "uri": "${replace("=${null_resource.generate_uri.id}=${file("webhookUri.txt")}", "=${null_resource.generate_uri.id}=", "")}",
            "expiryTime": "2030-01-01T00:00:00.000+00:00",
            "parameters": {},
            "runbook": {
            "name": "${azurerm_automation_runbook.github_membership_runbook.name}"
            }
        }
        }
    ]
  }
  TEMPLATE
}