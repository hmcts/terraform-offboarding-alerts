locals {
  webhook_uri = "https://dev.azure.com/${var.ado_org}/_apis/public/distributedtask/webhooks/${var.webhook_name}?api-version=6.0-preview"
}

resource "azurerm_resource_group" "main" {
  name     = "user-offboarding"
  location = "Uk South"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "DisabledUsersAlertsAction"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "disableduser"

  webhook_receiver {
    name                    = "Azure Devops - ${var.webhook_name}"
    service_uri             = local.webhook_uri
    use_common_alert_schema = false
  }

}
