variable "ado_org" {
  description = "The name of the Azure devops org where the webhook has been created"
  default     = "hmcts"
}

variable "webhook_name" {
  description = "The name of the webhook to send the notification to"

}
