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
  description = "This boolean will define wether or not owners will be contacted directly on expiring or expired secrets and certificates. All owners of the specific SP will be contacted, but owners where the secret or certificate has not yet expired will be contacted first. The owners will be contacted on the days specified in the 'email_inform_owners_days_with_warnings' variable (default: true)"
  type        = bool
  default     = true
}