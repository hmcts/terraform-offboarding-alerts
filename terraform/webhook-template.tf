data "azurerm_key_vault_secret" "webhook_uri" {
  name         = local.webhook_uri_secret_name
  key_vault_id = data.azurerm_key_vault.main.id

  depends_on = [null_resource.generate_webhook_uri]
}

resource "null_resource" "generate_webhook_uri" {
  provisioner "local-exec" {
    command = <<COMMAND
az login --service-principal --username $clientId --password $secret --tenant $tenantId
uri_api='https://management.azure.com/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.Automation/automationAccounts/${azurerm_automation_account.main.name}/webhooks/generateUri?api-version=2015-10-31'
uri=$(az rest -m post --header 'Accept=application/json' -u "$uri_api" -o tsv)
az keyvault secret set --vault-name ${data.azurerm_key_vault.main.name} --name ${local.webhook_uri_secret_name} --value "$uri"

  COMMAND
  }
}

resource "azurerm_resource_group_template_deployment" "main" {
  name                = "${var.runbook_name}-webook"
  resource_group_name = azurerm_resource_group.main.name
  deployment_mode     = "Incremental"
  template_content    = <<TEMPLATE
  {
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
        "name": "${azurerm_automation_account.main.name}/${local.webhook_name}",
        "type": "Microsoft.Automation/automationAccounts/webhooks",
        "apiVersion": "2015-10-31",
        "properties": {
            "isEnabled": true,
            "uri": "${data.azurerm_key_vault_secret.webhook_uri.value}",
            "expiryTime": "2030-01-01T00:00:00.000+00:00",
            "parameters": {},
            "runbook": {
            "name": "${azurerm_automation_runbook.main.name}"
            }
        }
        }
    ]
  }
  TEMPLATE
}