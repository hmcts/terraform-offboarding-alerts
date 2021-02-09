resource "azurerm_monitor_action_group" "github-membership-action-group" {
  name                = "DisabledUsersAlertsAction"
  resource_group_name = azurerm_resource_group.rg_github_membership.name
  short_name          = "disableduser"

  automation_runbook_receiver {
    name                    = "${var.runbook_name}_receiver"
    automation_account_id   = azurerm_automation_account.github_membership_automation.id
    runbook_name            = var.runbook_name
    webhook_resource_id     = "${azurerm_automation_account.github_membership_automation.id}/webhooks/webhook_alert"
    is_global_runbook       = true
    service_uri             = local.webhook_uri
    use_common_alert_schema = true
  }
}