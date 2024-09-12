########################################################
## Decide what features you want the check to perform ##
########################################################

resource "azurerm_automation_variable_bool" "email_Contact_email_get_list_of_orphaned_Service_Principals" {
  name                    = "email_Contact_email_get_list_of_orphaned_Service_Principals"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.email_Contact_email_get_list_of_orphaned_Service_Principals
  description             = "This will send an email to the governance team, with a list of all SP's that does not have an owner assigned"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_bool" "email_Contact_email_for_all_SPs_with_expired_secrets_status" {
  name                    = "email_Contact_email_for_all_SPs_with_expired_secrets_status"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.email_Contact_email_for_all_SPs_with_expired_secrets_status
  description             = "Enable this value to notify the governance or IT team about the status of all SP's with expired secrets or certificates"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_bool" "email_Contact_email_for_all_SPs_where_secret_is_about_to_expire" {
  name                    = "email_Contact_email_for_all_SPs_where_secret_is_about_to_expire"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.email_Contact_email_for_all_SPs_where_secret_is_about_to_expire
  description             = "This will send an email to the governance team, with a list of all SP's where the secret is about to expire"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_bool" "email_inform_owners_directly" {
  name                    = "email_inform_owners_directly"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.email_inform_owners_directly
  description             = "This value will define wether or not owners will be contacted directly on expiring or expired secrets and certificates"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "variable_application_id" {
  name                    = "application_id"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = azuread_application.service_principal_name_entra_id.client_id
  description             = "Client ID of SP used for getting expiration days for Entra ID secrets and certs"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "logic_app_url" {
  name                    = "logic_app_url"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = azurerm_logic_app_trigger_http_request.wf_la_expiration_notification.callback_url
  description             = "url path is stored in the keyvault. This is the corresponding name in the keyvault. Note: the url is the one that triggers the e-mail workflow"

  depends_on = [
    azurerm_automation_account.expiration-automation,
    azurerm_logic_app_trigger_http_request.wf_la_expiration_notification,
  ]
}

resource "azurerm_automation_variable_string" "key_vault_secret_key_name" {
  name                    = "key_vault_secret_key_name"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.key_vault_secret_key_name
  description             = "Identity of the secret in the keyvault that is used for the service principal that have access to see values in entra ID"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "key_vault_resource_name" {
  name                    = "key_vault_resource_name"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.key_vault_resource_name
  description             = "Name of the keyvault, being used to store secret data and shared data between powershell and Terraform"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "baseline_resource_group_name" {
  name                    = "baseline_resource_group_name"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = azurerm_resource_group.baseline_resource_group.name
  description             = "Resource group where all resources are deployed"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "secret_cert_days_to_expire" {
  name                    = "secret_cert_days_to_expire"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.secret_cert_days_to_expire
  description             = "Used in powershell script: Days until certificate or secret expires"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "subscription_id" {
  name                    = "subscription_id"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.subscription_id
  description             = "Used in powershell script: Provide subscription id for deployment"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "tenant_id" {
  name                    = "tenant_id"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.tenant_id
  description             = "Used in powershell script: Provide tenantid for the specific tenant. This is used during signin in the script"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "automation_account_solution_name" {
  name                    = "automation_account_solution_name"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.automation_account_solution_name
  description             = "Used in terraform. This is the automation account name used for the runbook running the extraction script"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "automationion_account_temp_storage_name" {
  name                    = "storage_account_temp_storage_account_name"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = azurerm_storage_container.blob_storage_temp.storage_account_name
  description             = "Created using terraform, used for temp storage of files for the e-mail send workflow"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "automationion_account_temp_storage_container_name" {
  name                    = "storage_account_container_name"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = azurerm_storage_container.blob_storage_temp.name
  description             = "Created using terraform, used for temp storage of files for the e-mail send workflow"

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_variable_string" "email_inform_owners_days_with_warnings" {
  name                    = "email_inform_owners_days_with_warnings"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.email_inform_owners_days_with_warnings
  description             = "Define with a string on which days the owner of a SP should receive the notification. eg. 0,1,2 means they will receive the email on the day it expires, 1 day before and 2 days before"

  depends_on = [azurerm_automation_account.expiration-automation]
}


resource "azurerm_automation_variable_string" "email_Contact_email_for_notification_emails" {
  name                    = "email_Contact_email_for_notification_emails"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  value                   = var.email_Contact_email_for_notification_emails
  description             = "This is the e-mail address that should be used to send a message about all the expiring secrets/certs where an owner could not be found: Note: they will be send as an attachement in CSV format"

  depends_on = [azurerm_automation_account.expiration-automation]
}

