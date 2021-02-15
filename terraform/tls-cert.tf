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

