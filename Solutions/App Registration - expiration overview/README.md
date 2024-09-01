# Intra ID Service Principals: Audit expiring secrets and certificates 

## intro

What you find in this repository, is a complete solution that will audit all service principals in a tenant and notify the owners (if any) and the e-mail address defined in the variables.

The concept of the files in this repo, is that you download and deploy the entire project and are provided a complete solution to handle the specific issue at hand. 

## Design

![Design](https://usercontent.one/wp/www.mmt-consult.dk/wp-content/uploads/2024/08/Intra-ID-Service-Principals_-Audit-expiring-secrets-and-certificates-Design-drawing-980x690.png)

For a full explanation of this repository, please read through the blog post here at: [mmt-consult.dk](https://www.mmt-consult.dk/intra-id-service-principals-audit-expiring-secrets-and-certificates/)

## Deployment

You don't need to make any changes in the terraform files or the script for the baseline solution to work. If you wish to customize it, then you can do that, but it will work out of the box. 

You have to configure the variables.tf file with the variables for your environment

### Requires customisation
#### email_Contact_email_for_notification_emails
*This is the e-mail address that should be used to send a message about all the expiring secrets/certs where an owner could not be found: Note: they will be send as an attachement in CSV format*

#### subscription_id
*Provide subscription id for deployment*

#### tenant_id
*Provide tenantid for the specific tenant. This is used during signin*

#### baseline_resource_group_name
*Resource group where all resources are deployed*

#### key_vault_resource_name
*Provide name for key-vault, The key vault will be used to store secrets that we don't wish to store in clear text*

#### automation_account_solution_name
*This is the name of the automation account. NOTE: This name has to be unique*

#### Communication_service_naming_convention
*This is a short name, that will be used in front of each of the communication services ressources. Name is used for ressources, so you can use it if you have a naming convetion etc.*

#### Service_Principal_name
*Service Principal name the application_id value. Used for connecting to Entra ID and collecting secrets and certificates*

#### key_vault_secret_key_name
*Identity of the secret used for the service principal that have access to see values in entra ID. This name is also used on the SP to identify the key*


### Default values
#### email_Contact_email_get_list_of_orphaned_Service_Principals
*This will send an email to the governance team, with a list of all SP's that does not have an owner assigned (default: true)*

#### email_Contact_email_for_all_SPs_with_expired_secrets_status
*Enable this value to notify the governance or IT team about the status of all SP's with expired secrets or certificates (default: true)*

#### email_Contact_email_for_all_SPs_where_secret_is_about_to_expire
*This will send an email to the governance team, with a list of all SP's where the secret is about to expire (default: true)*

#### email_inform_owners_directly
*This boolean will define wether or not owners will be contacted directly on expiring or expired secrets and certificates. All owners of the specific SP will be contacted. The owners will be contacted on the days specified in the 'email_inform_owners_days_with_warnings' variable (default: true)*

#### email_inform_owners_days_with_warnings
*Define with a string on which days the owner of a SP should receive the notification. eg. 0,1,2 means they will receive the email on the day it expires, 1 day before and 2 days before and so on. (default 1,2,3,4,5,6,7,14,21,28,30)*

#### secret_cert_days_to_expire
*Used in powershell script: the value here defines when a secret will be reported as expiring. (30 days default)*

#### logic_app_communication_service_primary_connection_string
*Identity of the secret used for the communication service. The name is irrelevant, but for good measure you can still choose on if you wish.*

#### location
*Define the datacenter where the solution should be deployed*
