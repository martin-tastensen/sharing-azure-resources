########################################################
## Decide what features you want the check to perform ##
########################################################

variable "email_Contact_email_get_list_of_orphaned_Service_Principals" {
  description = "This will send an email to the governance team, with a list of all SP's that does not have an owner assigned (default: true)"
  type        = bool
  default     = true
}

variable "email_Contact_email_for_all_SPs_with_expired_secrets_status" {
  description = "Enable this value to notify the governance or IT team about the status of all SP's with expired secrets or certificates (default: true)"
  type        = bool
  default     = true
}

variable "email_Contact_email_for_all_SPs_where_secret_is_about_to_expire" {
  description = "This will send an email to the governance team, with a list of all SP's where the secret is about to expire (default: true)"
  type        = bool
  default     = true
}

variable "email_inform_owners_directly" {
  description = "This boolean will define wether or not owners will be contacted directly on expiring or expired secrets and certificates. All owners of the specific SP will be contacted. The owners will be contacted on the days specified in the 'email_inform_owners_days_with_warnings' variable (default: true)"
  type        = bool
  default     = true
}

variable "email_inform_owners_days_with_warnings" {
  description = "Define with a string on which days the owner of a SP should receive the notification. eg. 0,1,2 means they will receive the email on the day it expires, 1 day before and 2 days before and so on. (default 1,2,3,4,5,6,7,14,21,28,30)"
  type        = string
  default     = "1,2,3,4,5,6,7,14,21,28,30"
}

variable "secret_cert_days_to_expire" {
  description = "Used in powershell script: the value here defines when a secret will be reported as expiring. (30 days default)"
  type        = string
  default     = "30"
}

####################################
##  Baseline resource information ##
####################################

variable "email_Contact_email_for_notification_emails" {
  description = "This is the e-mail address that should be used to send a message about all the expiring secrets/certs where an owner could not be found: Note: they will be send as an attachement in CSV format"
  type        = string
  default     = "martin@tastensen.dk"
}

variable "subscription_id" {
  description = "Provide subscription id for deployment"
  type        = string
  default     = "cb83e8c8-dcdd-4d25-8449-e727bd23b0f3"
}

variable "tenant_id" {
  description = "Provide tenantid for the specific tenant. This is used during signin"
  type        = string
  default     = "105f1023-7c86-4358-935f-b167313506fb"
}

variable "baseline_resource_group_name" {
  description = "Resource group where all resources are deployed"
  type        = string
  default     = "mts-secret-test-rg-p"
}

variable "key_vault_resource_name" {
  description = "Provide name for key-vault, The key vault will be used to store secrets that we don't wish to store in clear text"
  type        = string
  default     = "mts-keyvault-test-p"
}

variable "automation_account_solution_name" {
  description = "This is the name of the automation account. NOTE: This name has to be unique"
  type        = string
  default     = "mts-secret-verification-rb-p"
}

variable "Communication_service_naming_convention" {
  description = "This is a short name, that will be used in front of each of the communication services ressources. Name is used for ressources, so you can use it if you have a naming convetion etc."
  type        = string
  default     = "mmt-consult-p"
}

variable "Service_Principal_name" {
  description = "Service Principal name the application_id value. Used for connecting to Entra ID and collecting secrets and certificates"
  type        = string
  default     = "entra_id_secret_and_cert_audit_p"
}

variable "key_vault_secret_key_name" {
  description = "Identity of the secret used for the service principal that have access to see values in entra ID. This name is also used on the SP to identify the key"
  type        = string
  default     = "key-vault-expiry-p"
}

variable "logic_app_communication_service_primary_connection_string" {
  description = "Identity of the secret used for the communication service. The name is irrelevant, but for good measure you can still choose on if you wish."
  type        = string
  default     = "communication-service-primary-connection-string"
}