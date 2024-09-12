resource "azurerm_communication_service" "mmt-notification-service" {
  name                = "${var.Communication_service_naming_convention}-notify-service"
  resource_group_name = azurerm_resource_group.baseline_resource_group.name
  data_location       = "United States"
  tags                = local.tags
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

resource "azurerm_email_communication_service" "mmt-email-communication-service" {
  name                = "${var.Communication_service_naming_convention}-email-communication-service"
  resource_group_name = azurerm_resource_group.baseline_resource_group.name
  data_location       = "United States"
  tags                = local.tags
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

resource "azurerm_email_communication_service_domain" "AzureManagedDomain" {
  name             = "AzureManagedDomain"
  email_service_id = azurerm_email_communication_service.mmt-email-communication-service.id

  domain_management = "AzureManaged"
  tags              = local.tags
  depends_on = [
    azurerm_resource_group.baseline_resource_group,
    azurerm_email_communication_service.mmt-email-communication-service,
  ]
}

resource "azurerm_communication_service_email_domain_association" "update_linked_domain" {
  communication_service_id = azurerm_communication_service.mmt-notification-service.id
  email_service_domain_id  = azurerm_email_communication_service_domain.AzureManagedDomain.id
  depends_on = [
    azurerm_email_communication_service_domain.AzureManagedDomain,
    azurerm_email_communication_service.mmt-email-communication-service,
    azurerm_communication_service.mmt-notification-service,
  ]
}

# Save the connection string in the key vault for later use. 

resource "azurerm_key_vault_secret" "azurerm_communication_service_primary_connection_string" {
  name         = var.logic_app_communication_service_primary_connection_string
  value        = azurerm_communication_service.mmt-notification-service.primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault_resource_name.id
  depends_on = [
    azuread_application.service_principal_name_entra_id,
    azurerm_resource_group.baseline_resource_group
  ]
}

