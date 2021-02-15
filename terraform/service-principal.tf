resource "azuread_application" "automation_account" {
  display_name = "${var.automation_account_name}-automation-account"
}

resource "azuread_application_certificate" "automation_account" {
  application_object_id = azuread_application.automation_account.id
  type                  = "AsymmetricX509Cert"
  encoding              = "hex"
  value                 = azurerm_key_vault_certificate.automation_account.certificate_data
  end_date              = azurerm_key_vault_certificate.automation_account.certificate_attribute[0].expires

}

resource "azuread_service_principal" "automation_account" {
  application_id = azuread_application.automation_account.application_id

  depends_on = [azuread_application_certificate.automation_account]
}

resource "azuread_service_principal_certificate" "automation_account" {
  service_principal_id = azuread_service_principal.automation_account.id
  type                 = "AsymmetricX509Cert"
  encoding             = "hex"
  value                = azurerm_key_vault_certificate.automation_account.certificate_data
  end_date             = azurerm_key_vault_certificate.automation_account.certificate_attribute[0].expires
}

resource "azurerm_role_assignment" "key_vault" {
  scope                = data.azurerm_key_vault.cert_key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.automation_account.object_id
}