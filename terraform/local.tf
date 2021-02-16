locals {
  cert_name   = "${var.automation_account_name}-automation-account"
  webhook_uri = "https://${var.runbook_name}.webhook.uks.azure-automation.net/webhooks?token=${random_string.token1.result}%2b${random_string.token2.result}%3d"
}
