
locals {
  cert_name   = "${azurerm_automation_account.github_membership_automation.name}-connection"
  webhook_uri = "https://${var.runbook_name}.webhook.uks.azure-automation.net/webhooks?token=${random_string.token1.result}%2b${random_string.token2.result}%3d"
}


