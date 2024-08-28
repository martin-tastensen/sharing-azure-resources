# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
    azuread = {
      version = ">= 2.53.1"
      source  = "hashicorp/azuread"
    }
    #https://registry.terraform.io/providers/hashicorp/azuread/2.50.0

    azurerm = {
      version = ">= 3.116.0"
      source  = "hashicorp/azurerm"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }
  }
  #https://registry.terraform.io/providers/hashicorp/azurerm/3.105.0

}

provider "azapi" {}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
## Used for getting MS graph API permissions 
data "azuread_application_published_app_ids" "well_known" {}

## User for Entra ID information - eg - tenant name
data "azurerm_client_config" "current" {}



# az login --tenant "105f1023-7c86-4358-935f-b167313506fb"
# az account set --subscription "cb83e8c8-dcdd-4d25-8449-e727bd23b0f3"