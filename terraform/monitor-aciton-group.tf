resource "azurerm_monitor_action_group" "github-membership-action-group" {
  name                = "DisabledUsersAlertsAction"
  resource_group_name = azurerm_resource_group.rg_github_membership.name
  short_name          = "p0action"

  automation_runbook_receiver {
    name                    = "${var.runbook_name}_receiver"
    automation_account_id   = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourcegroups/github-membership-management/providers/microsoft.automation/automationaccounts/aaa001"
    runbook_name            = var.runbook_name
    webhook_resource_id     = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourcegroups/github-membership-management/providers/microsoft.automation/automationaccounts/aaa001/webhooks/webhook_alert"
    is_global_runbook       = true
    service_uri             = local.webhook_uri
    use_common_alert_schema = true
  }
}