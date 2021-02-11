resource "random_string" "token1" {
  length  = 20
  special = false
}

resource "random_string" "token2" {
  length  = 22
  special = false
}

variable "runbook_name" {
  description = "the name of the runbook"
}

locals {
  webhook_uri = "https://${var.runbook_name}.webhook.uks.azure-automation.net/webhooks?token=${random_string.token1.result}%2b${random_string.token2.result}%3d"
}

