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

variable "sp_display_name" {
  description = "The display name of the service principal that the automation account will assume"
}

variable "cert_keyvault" {
  description = "name of the keyvault to store the TLS cert in"
}

variable "cert_keyvault_rg" {
  description = "Resource group where the TLS cert will be stored"
}
