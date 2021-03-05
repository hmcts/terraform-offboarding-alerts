module "logworkspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = "prod"
}

resource "azurerm_monitor_scheduled_query_rules_alert" "main" {
  name                = "disabled_users_alert"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  action {
    action_group           = [azurerm_monitor_action_group.main.id]
    custom_webhook_payload = "{ \"IncludeSearchResults\": true, \"job\":\"user-offboarding\" }"
  }
  data_source_id = module.logworkspace.workspace_id
  description    = "Alert when at least one user account has been disabled"
  enabled        = true

  query       = <<-QUERY
  AuditLogs
    | where OperationName  == "Disable account" 
    | project TargetResources[0].userPrincipalName
  QUERY
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}