resource "azuread_application" "main" {
  display_name = "${var.automation_account_name}-automation-account"
}

resource "azuread_application_certificate" "main" {
  application_object_id = azuread_application.main.id
  type                  = "AsymmetricX509Cert"
  encoding              = "hex"
  value                 = azurerm_key_vault_certificate.main.certificate_data
  end_date              = azurerm_key_vault_certificate.main.certificate_attribute[0].expires

}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id

  depends_on = [azuread_application_certificate.main]
}

resource "azuread_service_principal_certificate" "main" {
  service_principal_id = azuread_service_principal.main.id
  type                 = "AsymmetricX509Cert"
  encoding             = "hex"
  value                = azurerm_key_vault_certificate.main.certificate_data
  end_date             = azurerm_key_vault_certificate.main.certificate_attribute[0].expires
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = data.azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_service_principal.main.object_id

  secret_permissions = [
    "get",
    "list"
  ]
}