# Intra ID Service Principals: Audit expiring secrets and certificates 
## Versioninfo
| Description  	| Value                   	|
|--------------	|-------------------------	|
| Version      	| 1.4.2                   	|
| Release date 	| 16. May 2025            	|
| Author       	| Martin Meiner Tastensen 	|

## intro

What you find in this repository, is a complete solution that will audit all service principals in a tenant and notify the owners (if any) and the e-mail address defined in the variables.

The concept of the files in this repo, is that you download and deploy the entire project and are provided a complete solution to handle the specific issue at hand. 

Before deploying, you will have to customize the solution to your own needs, the customization options are documented here. 

All changes will be saved in different versions, which should offer anyone the option to stay at a version and always be able to find it again. 

## Design

![Design](https://usercontent.one/wp/www.mmt-consult.dk/wp-content/uploads/2024/08/Intra-ID-Service-Principals_-Audit-expiring-secrets-and-certificates-Design-drawing-980x690.png)

For a full explanation of this repository, please read through the blog post here at: [mmt-consult.dk](https://www.mmt-consult.dk/entra-id-service-principals-audit-expiring-secrets-and-certificates-expanded/)



# Deployment
To deploy the setup above, you have to make a few changed to the variables file and I would recommend adding required tags in the local file aswell, but this is not required

If you wish to customize it, then you can do that, but be aware that a new version might break the changes done. If you upgrade and download a new version from here, i recommend that you verify and copy/paste your values from the variables.tf to the new version

## Update AZ modules
To ensure that the az modules in the automation account is up to date, please update them using the script in the support-scripts folder. 

By Default, the script will run one time after deployment. The versions are hardcoded to a version of the required modules that are supported. 

## Required customisation
Some details needs to be changed for the deployment to be successfull, there is a description of each of them on each of the variables in the variable.tf file, so I recommend that you read the description to ensure that you understand the effect that a change will have.


***
### email_Contact_email_get_list_of_orphaned_Service_Principals

**Description from variable.tf:**
*This will send an email to the governance team, with a list of all SP's that does not have an owner assigned (default: true)*

***
### email_Contact_email_for_all_SPs_with_expired_secrets_status

**Description from variable.tf:**
*Enable this value to notify the governance or IT team about the status of all SP's with expired secrets or certificates (default: true)*

***
### email_Contact_email_for_all_SPs_where_secret_is_about_to_expire

**Description from variable.tf:**
*This will send an email to the governance team, with a list of all SP's where the secret is about to expire (default: true)*

***
### email_inform_owners_directly

**Description from variable.tf:** 
*This boolean will define wether or not owners will be contacted directly on expiring or expired secrets and certificates.*

*All owners of the specific SP will be contacted, but owners where the secret or certificate has not yet expired will be contacted first*

*The owners will be contacted on the days specified in the 'email_inform_owners_days_with_warnings' variable (default: true)*

***
### email_inform_owners_days_with_warnings

**Description from variable.tf:** 
*Define with a string on which days the owner of a SP should receive the notification. eg. 0,1,2 means they will receive the email on the day it expires, 1 day before and 2 days before and so on.*

*(default 1,2,3,4,5,6,7,14,21,28,30)*

***
### secret_cert_days_to_expire

**Description from variable.tf:** 
*Used in powershell script: the value here defines when a secret will be reported as expiring. (30 days default)*

***
### Communication_service_naming_domain_type

**Description from variable.tf:** 
*Type in your custom domain (eg. notify.contoso.com), if you want it to be the domain you are using for the solution. Leave it as 'AzureManagedDomain' to create a Microsoft managed domain NOTE: There are a strict quota limit on this type*

For more details, please read the blog post where the reason for this value is described

***
### Communication_service_naming_domain_created_dns_records

**Description from variable.tf:** 
*Terraform will only create the last connections if this value is set to true (default: false).*

**Additional info:**
For more details, please read the blog post where the reason for this value is described

***
### email_define_domains_for_owner_notification_email

**Description from variable.tf:** 
*When looking through owners, it will own send an e-mail if the owner is from one of these approved domains*

**Additional info:**
Add the domains that should receive the e-mail. The concept is that the addresses here will be used in a whitelist. This can also be used in cases where the E-mail address and UPN are not identical, and thus you can simply add the public domain here, ensuring that the users will receive the notification e-mail

***
### email_define_domains_for_owner_notification_email_enable

**Description from variable.tf:** 
*If true, the script will look at the domains in the var.email_define_domains_for_owner_notification_email and only send e-mail to users who have an e-mail in this domain at either the primary e-mail field or the othermails field in entra ID*

***
### email_Contact_email_for_notification_emails

**Description from variable.tf:** 
*This is the e-mail address that should be used to send a message about all the expiring secrets/certs where an owner could not be found: Note: they will be send as an attachement in CSV format*

***
### subscription_id

**Description from variable.tf:** 
*Provide subscription id for deployment*

***
### tenant_id

**Description from variable.tf:** 
*Provide tenantid for the specific tenant. This is used during signin*

***
### baseline_resource_group_name

**Description from variable.tf:** 
*Resource group where all resources are deployed*

***
### key_vault_resource_name

**Description from variable.tf:** 
*Provide name for key-vault, The key vault will be used to store secrets that we don't wish to store in clear text*

***
### automation_account_solution_name

**Description from variable.tf:** 
*This is the name of the automation account. NOTE: This name has to be unique*

***
### Communication_service_naming_convention

**Description from variable.tf:** 
*This is a short name, that will be used in front of each of the communication services ressources. Name is used for ressources, so you can use it if you have a naming convetion etc.*

***
### Service_Principal_name

**Description from variable.tf:** 
*Service Principal name the application_id value. Used for connecting to Entra ID and collecting secrets and certificates*

***
### key_vault_secret_key_name

**Description from variable.tf:** 
*Identity of the secret used for the service principal that have access to see values in entra ID. This name is also used on the SP to identify the key*

***
### logic_app_communication_service_primary_connection_string

**Description from variable.tf:** 
Identity of the secret used for the communication service.

***
### location

**Description from variable.tf:** 
Define the datacenter where the resources should be deployed

***
### data_location_region

**Description from variable.tf:** 
*on creation of the communication service, a location is required. This is not a datacenter but a regio, posibilities are Africa, Asia Pacific, Australia, Brazil, Canada, Europe, France, Germany, India, Japan, Korea, Norway, Switzerland, UAE, UK and United States*

