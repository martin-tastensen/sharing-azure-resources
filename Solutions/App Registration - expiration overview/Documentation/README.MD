# Documentation 

This page will show the documentation for how to configure everything needed to run this secret and audit tool

# Concept
This solution is deployed using Terraform. It deploys all the resources needed for it to run and allows you to decide which features you wish to use.

I have split the documentation into multiple subfolders. There is a general short description of each on this page, but to avoid things getting chaotic, each section refers to a subpage that details what the specific setting does.

# Configuration

## Prerequisites
### User running Terraform – these permissions are only required during deployment or updates:

- Create new service principal.
- Create new resource group.
- Set permission on resource group and resources inside the resource group.
- Add secret to key vault (e.g. key vault secrets officer).

### Service principal created using Terraform:
- API permissions (someone needs to approve these AFTER Terraform has run).
  - Microsoft Graph
    - Application.Read.All
      - This is used to get the required information about when a secret or certificate is expiring and who the owner of the service principal is.
    - Organization.Read.All
    - User.Read.All
      - This is required to find information about the service principal owner.

### Terraform
The client executing the code must have Terraform installed. [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
is free to use and can be installed using the Install Terraform guide on the HashiCorp homepage.

You can read my guide on getting started [here](https://www.mmt-consult.dk/terraform-getting-started/) 

### Azure CLI
To use Terraform with Azure, you need the Azure CLI. Please refer to [Microsoft Learn](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-cli&pivots=winget) for instructions on installation.

## Variables
All resources are deployed through variables. Each variable is briefly described below, with links to dedicated pages that provide a deeper explanation of its purpose and available values.

### variables.feature_activation.tf
- [email_Contact_email_get_list_of_orphaned_Service_Principals](#email_Contact_email_get_list_of_orphaned_Service_Principals)
- [email_Contact_email_for_all_SPs_with_expired_secrets_status](#email_Contact_email_for_all_SPs_with_expired_secrets_status)
- [email_Contact_email_for_all_SPs_where_secret_is_about_to_expire](#email_Contact_email_for_all_SPs_where_secret_is_about_to_expire)
- [email_inform_owners_directly](#email_inform_owners_directly)

### variables.resources.tf
- [subscription_id](#subscription_id)
- [tenant_id](#tenant_id)
- [baseline_resource_group_name](#baseline_resource_group_name)
- [key_vault_resource_name](#key_vault_resource_name)
- [automation_account_solution_name](#automation_account_solution_name)
- [Communication_service_naming_convention](#Communication_service_naming_convention)
- [location](#subscrilocationtion_id)
- [logic_app_communication_service_primary_connection_string](#logic_app_communication_service_primary_connection_string)
- [Service_Principal_name](#Service_Principal_name)
- [key_vault_secret_key_name](#key_vault_secret_key_name)

### variables.communication.tf
- [email_inform_owners_days_with_warnings](#email_inform_owners_days_with_warnings)
- [secret_cert_days_to_expire](#secret_cert_days_to_expire)
- [domain_type - Communication_service_naming_domain_type](#domain_type---Communication_service_naming_domain_type)
- [domain_type - Communication_service_naming_domain_created_dns_records](#domain_type---Communication_service_naming_domain_created_dns_records)
- [destination_approved_domains - email_define_domains_for_owner_notification_email](#destination_approved_domains---email_define_domains_for_owner_notification_email)
- [destination_approved_domains - email_define_domains_for_owner_notification_email_enable](#destination_approved_domains---email_define_domains_for_owner_notification_email_enable)
- [contact_configuration_for_notification_emails - email_Contact_email_for_notification_emails](#contact_configuration_for_notification_emails---email_Contact_email_for_notification_emails)
- [contact_configuration_for_notification_emails - email_Contact_email_for_notification_emails_add_date](#contact_configuration_for_notification_emails---email_Contact_email_for_notification_emails_add_date)

### variables.diagnostics.tf
- [diagnostics_settings](#diagnostics_settings)
- [diagnostics_settings_retention_period](#diagnostics_settings_retention_period)

*** 

### email_Contact_email_get_list_of_orphaned_Service_Principals
**File:** variables.feature_activation.tf </br></br>
This will send an email to the governance team, with a list of all SP's that does not have an owner assigned (default: true)


[Documentation](detailed_docs/variables.feature_activation/email_Contact_email_get_list_of_orphaned_Service_Principals.md)


***

### email_Contact_email_for_all_SPs_with_expired_secrets_status
**File:** variables.feature_activation.tf </br></br>
Enable this value to notify the governance or IT team about the status of all SP's with expired secrets or certificates (default: true)

[Documentation](detailed_docs/variables.feature_activation/email_Contact_email_for_all_SPs_with_expired_secrets_status.md)

***

### email_Contact_email_for_all_SPs_where_secret_is_about_to_expire
**File:** variables.feature_activation.tf </br></br>
This will send an email to the governance team, with a list of all SP's where the secret is about to expire (default: true)

[Documentation](detailed_docs/variables.feature_activation/email_Contact_email_for_all_SPs_where_secret_is_about_to_expire.md)

***

### email_inform_owners_directly
**File:** variables.feature_activation.tf </br></br>
This boolean will define wether or not owners will be contacted directly on expiring or expired secrets and certificates. All owners of the specific SP will be contacted, but owners where the secret or certificate has not yet expired will be contacted first. The owners will be contacted on the days specified in the 'email_inform_owners_days_with_warnings' variable (default: true)

[Documentation](detailed_docs/variables.feature_activation/email_inform_owners_directly.md)

***

### subscription_id
**File:** variables.resources.tf</br></br>
Provide subscription id for deployment

[Documentation](detailed_docs/variables.resources/subscription_id.md)

***

### tenant_id
**File:** variables.resources.tf</br></br>
Provide tenantid for the specific tenant. This is used during signin

[Documentation](detailed_docs/variables.resources/tenant_id.md)

***

### baseline_resource_group_name
**File:** variables.resources.tf</br></br>
Resource group where all resources are deployed

[Documentation](detailed_docs/variables.resources/baseline_resource_group_name.md)

***

### key_vault_resource_name
**File:** variables.resources.tf</br></br>
Provide name for key-vault, The key vault will be used to store secrets that we don't wish to store in clear text (max 24 characters)

[Documentation](detailed_docs/variables.resources/key_vault_resource_name.md)

***

### automation_account_solution_name
**File:** variables.resources.tf</br></br>
This is the name of the automation account. NOTE: This name has to be unique

[Documentation](detailed_docs/variables.resources/automation_account_solution_name.md)

***

### Communication_service_naming_convention
**File:** variables.resources.tf</br></br>
This is a short name, that will be used in front of each of the communication services ressources. Name is used for ressources, so you can use it if you have a naming convetion etc.

[Documentation](detailed_docs/variables.resources/Communication_service_naming_convention.md)

***

### location
**File:** variables.resources.tf</br></br>
Define the datacenter where the resources should be deployed

[Documentation](detailed_docs/variables.resources/location.md)

***

### data_location_region
**File:** variables.resources.tf</br></br>
on creation of the communication service, a location is required. This is not a datacenter but a regio, posibilities are Africa, Asia Pacific, Australia, Brazil, Canada, Europe, France, Germany, India, Japan, Korea, Norway, Switzerland, UAE, UK and United States

[Documentation](detailed_docs/variables.resources/data_location_region.md)

***

### logic_app_communication_service_primary_connection_string
**File:** variables.resources.tf</br></br>
Identity of the secret used for the communication service

[Documentation](detailed_docs/variables.resources/logic_app_communication_service_primary_connection_string.md)

***

### Service_Principal_name
**File:** variables.resources.tf</br></br>
Service Principal name the application_id value. Used for connecting to Entra ID and collecting secrets and certificates

[Documentation](detailed_docs/variables.resources/Service_Principal_name.md)

***

### key_vault_secret_key_name
**File:** variables.resources.tf</br></br>
Identity of the secret used for the service principal that have access to see values in entra ID. This name is also used on the SP to identify the key

[Documentation](detailed_docs/variables.resources/key_vault_secret_key_name.md)

***

### email_inform_owners_days_with_warnings
**File:** variables.communication.tf </br></br>
Define with a string on which days the owner of a SP should receive the notification. eg. 0,1,2 means they will receive the email on the day it expires, 1 day before and 2 days before and so on. (default 1,2,3,4,5,6,7,14,21,28,30)

[Documentation](detailed_docs/variables.communication/email_inform_owners_days_with_warnings.md)

***

### secret_cert_days_to_expire
**File:** variables.communication.tf </br></br>
Used in powershell script: the value here defines when a secret will be reported as expiring. (30 days default)

[Documentation](detailed_docs/variables.communication/secret_cert_days_to_expire.md)

***

### domain_type - Communication_service_naming_domain_type
**File:** variables.communication.tf </br></br>
Type in your custom domain (eg. notify.contoso.com), if you want it to be the domain you are using for the solution. Leave it as 'AzureManagedDomain' to create a Microsoft managed domain NOTE: There are a strict quota limit on this type.

[Documentation](detailed_docs/variables.communication/domain_type/Communication_service_naming_domain_type.md)

***

### domain_type - Communication_service_naming_domain_created_dns_records
**File:** variables.communication.tf </br></br>
Terraform will only create the last connections if this value is set to true (default: false). Must be false until domain has been confirmed.

[Documentation](detailed_docs/variables.communication/domain_type/Communication_service_naming_domain_created_dns_records.md)

***

### destination_approved_domains - email_define_domains_for_owner_notification_email
**File:** variables.communication.tf </br></br>
When looking through owners, it will own send an e-mail if the owner is from one of these approved domains

[Documentation](detailed_docs/variables.communication/destination_approved_domains/email_define_domains_for_owner_notification_email.md)

***

### destination_approved_domains - email_define_domains_for_owner_notification_email_enable
**File:** variables.communication.tf </br></br>
If true, the script will look at the domains in the var.email_define_domains_for_owner_notification_email and only send e-mail to users who have an e-mail in this domain at either the primary e-mail field or the othermails field in entra ID

[Documentation](detailed_docs/variables.communication/destination_approved_domains/email_define_domains_for_owner_notification_email_enable.md)

***

### contact_configuration_for_notification_emails - email_Contact_email_for_notification_emails
**File:** variables.communication.tf </br></br>
This is the e-mail addresses that should be used to send a message about all the expiring secrets/certs where an owner could not be found: Note: they will be send as an attachement in CSV format. You can define multiple e-mails here if you wish to

[Documentation](detailed_docs/variables.communication/contact_configuration_for_notification_emails/email_Contact_email_for_notification_emails.md)

***

### contact_configuration_for_notification_emails - email_Contact_email_for_notification_emails_add_date
**File:** variables.communication.tf </br></br>
If set to true, it will add the date of the report to the filename for the notification e-mails.

[Documentation](detailed_docs/variables.communication/contact_configuration_for_notification_emails/email_Contact_email_for_notification_emails_add_date.md)

***