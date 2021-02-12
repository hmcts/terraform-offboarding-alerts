data "azuread_service_principal" "automation_account_sp" {
  display_name = var.sp_display_name
}

data "azuread_application" "automation_account_app" {
  display_name = var.sp_display_name
}

resource "azurerm_key_vault_certificate" "automation_account_cert" {
  name         = local.cert_name
  key_vault_id = data.azurerm_key_vault.cert_key_vault.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.2"]

      key_usage = [
        "dataEncipherment",
        "digitalSignature",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${azurerm_automation_account.github_membership_automation.name}-automation-account"
      validity_in_months = 12
    }
  }
}

resource "azuread_application_certificate" "main" {
  application_object_id = data.azuread_application.automation_account_app.object_id
  type                  = "AsymmetricX509Cert"
  encoding              = "hex"
  value                 = azurerm_key_vault_certificate.automation_account_cert.certificate_data
  end_date              = azurerm_key_vault_certificate.automation_account_cert.certificate_attribute[0].expires

}

resource "azuread_service_principal_certificate" "main" {
  service_principal_id = data.azuread_service_principal.automation_account_sp.application_id
  type                 = "AsymmetricX509Cert"
  encoding             = "hex"
  value                = azurerm_key_vault_certificate.automation_account_cert.certificate_data
  end_date             = azurerm_key_vault_certificate.automation_account_cert.certificate_attribute[0].expires
}
