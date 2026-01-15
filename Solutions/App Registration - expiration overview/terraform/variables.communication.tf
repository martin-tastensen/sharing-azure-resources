##############################################
##  Define when the alarms should be send.  ##
##############################################

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

############################################################################################################
##  Define if you wish to use a Azure Managed domain, or custom. Please read the readme for more guidance ##
############################################################################################################

variable "domain_type" {
  type = map(object({
    value_string = optional(string)
    value_bool   = optional(bool)
    description  = string
  }))
  default = {
    Communication_service_naming_domain_type = {
      value_string = "AzureManagedDomain"
      description  = "Type in your custom domain (eg. notify.contoso.com), if you want it to be the domain you are using for the solution. Leave it as 'AzureManagedDomain' to create a Microsoft managed domain NOTE: There are a strict quota limit on this type."
    }
    Communication_service_naming_domain_created_dns_records = {
      value_bool  = false
      description = "Terraform will only create the last connections if this value is set to true (default: false). Must be false until domain has been confirmed."
    }
  }
}

######################################################################################################################
##  Define which domains should receive the e-mail as owner. Note, this is primarily focused towards guest accounts ##
######################################################################################################################

variable "destination_approved_domains" {
  type = map(object({
    value_string = optional(list(string))
    value_bool   = optional(bool)
    description  = string
  }))
  default = {
    email_define_domains_for_owner_notification_email = {
      value_string = [
        "domain1.com",
        "domain2.com",
        "domain3.com"
      ]
      description = "When looking through owners, it will own send an e-mail if the owner is from one of these approved domains"
    }
    email_define_domains_for_owner_notification_email_enable = {
      value_bool  = false
      description = "If true, the script will look at the domains in the var.email_define_domains_for_owner_notification_email and only send e-mail to users who have an e-mail in this domain at either the primary e-mail field or the othermails field in entra ID (default: false)"
    }
  }
}

variable "contact_configuration_for_notification_emails" {
  type = map(object({
    value_string = optional(list(string))
    value_bool   = optional(bool)
    description  = string
  }))
  default = {
    email_Contact_email_for_notification_emails = {
      value_string = [
        "support@contoso.com",
        "ciso@contoso.com"
      ]
      description = "This is the e-mail addresses that should be used to send a message about all the expiring secrets/certs where an owner could not be found: Note: they will be send as an attachement in CSV format. You can define multiple e-mails here if you wish to"
    }
    email_Contact_email_for_notification_emails_add_date = {
      value_bool  = true
      description = "If set to true, it will add the date of the report to the filename for the notification e-mails. (Not yet implemented)"
    }
  }
}