locals {
  cert_name               = "${var.automation_account_name}-automation-account-auth"
  webhook_name            = "${var.runbook_name}-webhook"
  webhook_uri_secret_name = "webhook-uri-${var.automation_account_name}"
}
