module "logworkspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = "prod"
}

data "azurerm_key_vault" "main" {
  name                = "cftptl-intsvc"
  resource_group_name = "core-infra-intsvc-rg"
}

resource "random_string" "random" {
  count   = 3
  length  = 6
  special = false
}


resource "azurerm_key_vault_secret" "main" {
  name         = "user-offboarding-webhook-token"
  value        = "${random_string.random[0].result}-${random_string.random[1].result}-${random_string.random[2].result}"
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_monitor_scheduled_query_rules_alert" "main" {
  name                = "disabled_users_alert"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  action {
    action_group           = [azurerm_monitor_action_group.main.id]
    custom_webhook_payload = "{ \"IncludeSearchResults\": true, \"token\":\"${azurerm_key_vault_secret.main.value}\" }"
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