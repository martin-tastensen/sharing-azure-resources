## Create Keyvault for secret SP secret storage
resource "azurerm_key_vault" "key_vault_resource_name" {
  name                        = var.key_vault_resource_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.baseline_resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

## Create SP and assign the API permissions as required to the account.

resource "azuread_application" "service_principal_name_entra_id" {
  display_name = var.Service_Principal_name
  notes        = "Used in relation to audit mail, being send out to owners of SP where the secret/cert is about to expire ot expired"
  owners = [data.azurerm_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "9a5d68dd-52b0-4cc2-bd40-abcf44ac3a30" # Application.Read.All, https://learn.microsoft.com/en-us/graph/permissions-reference#applicationreadall
      type = "Role"
    }

    resource_access {
      id   = "498476ce-e0fe-48b0-b801-37ba7e2685c6" # Organization.Read.All, https://learn.microsoft.com/en-us/graph/permissions-reference#organizationreadall
      type = "Role"
    }

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All, https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall
      type = "Role"
    }

  }
}

# Permissions for the user running the terraform apply. This will be the signed in user. THe user will be granted access to save and read keys in the keyvault
resource "azurerm_role_assignment" "assign_key_vault_Secrets_officer_to_executing_user" {
  scope                = azurerm_resource_group.baseline_resource_group.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [azurerm_resource_group.baseline_resource_group]
}

## Assign permissions to the keyvault for the system managed identity
resource "azurerm_role_assignment" "assign_key_vault_Secrets_officer_to_System_identity" {
  scope                = azurerm_resource_group.baseline_resource_group.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_automation_account.expiration-automation.identity[0].principal_id

  depends_on = [azurerm_resource_group.baseline_resource_group]
}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

resource "azuread_application_password" "Terraformgenerated" {
  display_name   = var.key_vault_secret_key_name
  application_id = azuread_application.service_principal_name_entra_id.id
  depends_on = [
    azuread_application.service_principal_name_entra_id,
    azurerm_resource_group.baseline_resource_group
  ]
}

resource "azurerm_key_vault_secret" "Save_key" {
  name         = var.key_vault_secret_key_name
  value        = azuread_application_password.Terraformgenerated.value
  key_vault_id = azurerm_key_vault.key_vault_resource_name.id
  depends_on = [
    azuread_application.service_principal_name_entra_id,
    azurerm_resource_group.baseline_resource_group
  ]
}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "assign_storage_account_Storage_Blob_data_owner_to_executing_user" {
  scope                = azurerm_storage_account.storage_account_temp_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_resource_group.baseline_resource_group,
    azurerm_storage_account.storage_account_temp_storage
  ]
}

## Assign permissions to the Storage account for the system managed identity
resource "azurerm_role_assignment" "assign_storage_account_Storage_Blobl_data_Contributor_to_System_identity" {
  scope                = azurerm_storage_account.storage_account_temp_storage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_automation_account.expiration-automation.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.baseline_resource_group,
    azurerm_storage_account.storage_account_temp_storage
  ]
}

## Assign permissions to the Storage account for the system managed identity
resource "azurerm_role_assignment" "assign_storage_account_Storage_Blobl_data_Contributor_to_System_identity1" {
  scope                = azurerm_storage_account.storage_account_temp_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_logic_app_workflow.la_expiration_notification.identity[0].principal_id

  depends_on = [
    azurerm_resource_group.baseline_resource_group,
    azurerm_storage_account.storage_account_temp_storage,
    azurerm_logic_app_workflow.la_expiration_notification,
  ]
}