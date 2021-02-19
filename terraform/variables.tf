variable "automation_account_name" {
  description = "The name of the Automation Account"
}

variable "runbook_name" {
  description = "the name of the runbook"
}

variable "cert_keyvault" {
  description = "name of the keyvault to store the TLS cert in"
}

variable "cert_keyvault_rg" {
  description = "Resource group where the TLS cert will be stored"
}