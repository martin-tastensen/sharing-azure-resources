variable "keyvault_owners" {
  type = map(object({
    value_string = optional(list(string))
    description  = string
  }))
  default = {
    owner_upn = {
      value_string = [
        "abc@contoso.com",
        "defg_contoso.com#EXT#@contoso.onmicrosoft.com"
      ]
      description = "The users specified here will be assigned as Key Vault Secrets Officer. These users will be able to see the connection string etc. Note: The value needs to be the users UPN"
    }
  }
}

variable "Service_Principal_owners" {
  type = map(object({
    value_string = optional(list(string))
    description  = string
  }))
  default = {
    owner_upn = {
      value_string = [
        "abc@contoso.com",
        "defg_contoso.com#EXT#@contoso.onmicrosoft.com"
      ]
      description = "The users specified here will be assigned as owner of the service principal. These users will be able to create secrets etc. for the SP"
    }
  }
}

variable "storage_account_owners" {
  type = map(object({
    value_string = optional(list(string))
    description  = string
  }))
  default = {
    owner_upn = {
      value_string = [
        "abc@contoso.com",
        "defg_contoso.com#EXT#@contoso.onmicrosoft.com"
      ]
      description = "The users specified here will be assigned as owner of the storage account. These users will be able to create secrets etc. for the SP"
    }
  }
}