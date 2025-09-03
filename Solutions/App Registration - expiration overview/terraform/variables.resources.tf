variable "custom_tags" {
  description = ""
  type        = map(string)
  default = {
    "Environment" = "Production"
  }
}

variable "subscription_id" {
  description = "Provide subscription id for deployment"
  type        = string
  default     = "<subscription id>"
}

variable "tenant_id" {
  description = "Provide tenantid for the specific tenant. This is used during signin"
  type        = string
  default     = "<tenant id>"
}

variable "baseline_resource_group_name" {
  description = "Resource group where all resources are deployed"
  type        = string
  default     = "<resource group name>"
}

variable "key_vault_resource_name" {
  description = "Provide name for key-vault, The key vault will be used to store secrets that we don't wish to store in clear text (max 24 characters)"
  type        = string
  default     = "<key vault ressource name>"
}

variable "automation_account_solution_name" {
  description = "This is the name of the automation account. NOTE: This name has to be unique"
  type        = string
  default     = "<automation account name>"
}

variable "Communication_service_naming_convention" {
  description = "This is a short name, that will be used in front of each of the communication services ressources. Name is used for ressources, so you can use it if you have a naming convetion etc."
  type        = string
  default     = "<shortname for cummincation service items>"
}

variable "location" {
  description = "Define the datacenter where the resources should be deployed"
  type        = string
  default     = "sweden central"
}

variable "data_location_region" {
  description = "on creation of the communication service, a location is required. This is not a datacenter but a regio, posibilities are Africa, Asia Pacific, Australia, Brazil, Canada, Europe, France, Germany, India, Japan, Korea, Norway, Switzerland, UAE, UK and United States"
  type        = string
  default     = "Europe"
}

#######################################################################################################################
## All of the below variables have an acceptable name, and none unique name, but you can change it if you desire to ##
#######################################################################################################################


variable "logic_app_communication_service_primary_connection_string" {
  description = "Identity of the secret used for the communication service."
  type        = string
  default     = "communication-service-primary-connection-string"
}

variable "Service_Principal_name" {
  description = "Service Principal name the application_id value. Used for connecting to Entra ID and collecting secrets and certificates"
  type        = string
  default     = "<service principal name>"
}

variable "key_vault_secret_key_name" {
  description = "Identity of the secret used for the service principal that have access to see values in entra ID. This name is also used on the SP to identify the key"
  type        = string
  default     =  "automation-audit-user-secret"
}