resource "azurerm_monitor_action_group" "main" {
  name                = "DisabledUsersAlertsAction"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "disableduser"

  automation_runbook_receiver {
    name                    = "${var.runbook_name}_receiver"
    automation_account_id   = azurerm_automation_account.main.id
    runbook_name            = var.runbook_name
    webhook_resource_id     = "${azurerm_automation_account.main.id}/webhooks/${local.webhook_name}"
    is_global_runbook       = false
    service_uri             = data.azurerm_key_vault_secret.webhook_uri.value
    use_common_alert_schema = true
  }
}
