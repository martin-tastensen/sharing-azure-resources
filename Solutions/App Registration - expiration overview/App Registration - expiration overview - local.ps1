<#
.COPYRIGHT
Copyright (c) MMT Consult. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.

Version 1.2.0
Author: Martin Meiner Tästensen
contact: support@mmt-consult.dk
#>


######################################################################
# Insert the data from the variables on the automation account below # 
######################################################################
# Connect to get access to automation account variables
$tenant_id = "<insert tenant id<"
$subscription_id = "<insert subscription id>"

#Define automation account varibles - rest of the variables should be collected from the automation account variables
$var_automationaccount = "<automation account name>" 
$var_resourcegroupname = "<Resource Group name>"

Connect-AzAccount -Subscription $subscription_id -Tenant $tenant_id 

$tenant_id = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name tenant_id
$tenant_id = $tenant_id.value
Write-Output = "tenant_id = $tenant_id"

$subscription_id = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name subscription_id
$subscription_id = $subscription_id.value
Write-Output = "subscription_id = $subscription_id "

$application_id = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name application_id
$application_id = $application_id.value
Write-Output = "application_id = $application_id "

$secret_cert_days_to_expire = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name secret_cert_days_to_expire
$secret_cert_days_to_expire = $secret_cert_days_to_expire.Value
Write-Output = "secret_cert_days_to_expire = $secret_cert_days_to_expire"

$key_vault_resource_name = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name key_vault_resource_name
$key_vault_resource_name = $key_vault_resource_name.value
Write-Output = "key_vault_resource_name = $key_vault_resource_name "

$key_vault_secret_key_name = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name key_vault_secret_key_name
$key_vault_secret_key_name = $key_vault_secret_key_name.value
Write-Output = "key_vault_secret_key_name = $key_vault_secret_key_name" 

$logic_app_url = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name logic_app_url
$logic_app_url = $logic_app_url.value
Write-Output = "logic_app_url = $logic_app_url "

$storage_account_container_name = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name storage_account_container_name
$storage_account_container_name = $storage_account_container_name.value
Write-Output = "storage_account_container_name = $storage_account_container_name "

$storage_account_temp_storage_account_name = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name storage_account_temp_storage_account_name
$storage_account_temp_storage_account_name = $storage_account_temp_storage_account_name.value
Write-Output = "storage_account_temp_storage_account_name = $storage_account_temp_storage_account_name"

$baseline_resource_group_name = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name baseline_resource_group_name
$baseline_resource_group_name = $baseline_resource_group_name.value
Write-Output = "baseline_resource_group_name = $baseline_resource_group_name "

$email_inform_owners_directly = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_inform_owners_directly
$email_inform_owners_directly = $email_inform_owners_directly.Value
Write-Output "email_inform_owners_directly = $email_inform_owners_directly" 


$email_inform_owners_days_with_warnings = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_inform_owners_days_with_warnings
$email_inform_owners_days_with_warnings = $email_inform_owners_days_with_warnings.Value
Write-Output "email_inform_owners_days_with_warnings = $email_inform_owners_days_with_warnings"


$email_Contact_email_for_all_SPs_with_expired_secrets_status = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_Contact_email_for_all_SPs_with_expired_secrets_status
$email_Contact_email_for_all_SPs_with_expired_secrets_status = $email_Contact_email_for_all_SPs_with_expired_secrets_status.value
Write-Output "email_Contact_email_for_all_SPs_with_expired_secrets_status = $email_Contact_email_for_all_SPs_with_expired_secrets_status"

$email_Contact_email_for_all_SPs_where_secret_is_about_to_expire = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_Contact_email_for_all_SPs_where_secret_is_about_to_expire
$email_Contact_email_for_all_SPs_where_secret_is_about_to_expire = $email_Contact_email_for_all_SPs_where_secret_is_about_to_expire.value
Write-Output "email_Contact_email_for_all_SPs_where_secret_is_about_to_expire = $email_Contact_email_for_all_SPs_where_secret_is_about_to_expire"


$email_Contact_email_for_notification_emails = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_Contact_email_for_notification_emails
$email_Contact_email_for_notification_emails = $email_Contact_email_for_notification_emails.Value
Write-Output "email_Contact_email_for_notification_emails = $email_Contact_email_for_notification_emails"

$email_Contact_email_get_list_of_orphaned_Service_Principals = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_Contact_email_get_list_of_orphaned_Service_Principals
$email_Contact_email_get_list_of_orphaned_Service_Principals = $email_Contact_email_get_list_of_orphaned_Service_Principals.value
Write-Output "email_Contact_email_get_list_of_orphaned_Service_Principals = $email_Contact_email_get_list_of_orphaned_Service_Principals"

$email_define_domains_for_owner_notification_email_enable = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_define_domains_for_owner_notification_email_enable
$email_define_domains_for_owner_notification_email_enable = $email_define_domains_for_owner_notification_email_enable.value
Write-Output "email_define_domains_for_owner_notification_email = $email_define_domains_for_owner_notification_email_enable"

$email_define_domains_for_owner_notification_email = Get-AzAutomationVariable -ResourceGroupName $var_resourcegroupname -AutomationAccountName $var_automationaccount -Name email_define_domains_for_owner_notification_email
$email_define_domains_for_owner_notification_email = $email_define_domains_for_owner_notification_email.value
Write-Output "email_define_domains_for_owner_notification_email = $email_define_domains_for_owner_notification_email"

#########################################
# Sign-in with system assigned identity # 
#########################################
$stopwatch = [system.diagnostics.stopwatch]::StartNew()
# process borrowed from MS learn:
# https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation#authenticate-access-with-system-assigned-managed-identity

##################################
# Sign-in with Service Principal # 
##################################

# Get secrets in key vault
$key_vault_secrets = Get-AzKeyVaultSecret -VaultName $key_vault_resource_name -Name $key_vault_secret_key_name
foreach($key in $key_vault_secrets)
{
    if($key.Enabled -eq $true)
    {
        $client_secret = $key.Secretvalue | ConvertFrom-SecureString -AsPlainText
    }
}

# sign in to mg-graph module with app registration
# Prepare Token
$body =  @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $application_id  
    Client_Secret = $client_secret
}

    $connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$tenant_id/oauth2/v2.0/token `
    -Method POST `
    -Body $body

# Get the access token, save it to secure string for later use
# $Token = $Connection.access_token | ConvertTo-SecureString -AsPlainText -Force
$Token = $Connection.access_token

# Connect to the mggraph module in powershell
#Connect-MgGraph -AccessToken $token -NoWelcome
Connect-MgGraph -AccessToken ($token |ConvertTo-SecureString -AsPlainText -Force)

#############################################################################################################################

# Calculate when the date for when to send a warning
$date_today = Get-Date
$expirationdate = ($date_today).AddDays("+" + $secret_cert_days_to_expire)


# Get the tenant name, used for the export later
$tenant_details = (Get-AzContext).Tenant.Id
$tenant_name = (Get-AzTenant | where-object Id -eq $tenant_details).Name
Write-Output $tenant_name

# Get list of all Service Principals in the tenant
$App_registrations = Get-MgApplication -All -Property Id,DisplayName,AppId,AdditionalProperties,PasswordCredentials,keyCredentials,CreatedDateTime

#Get a list of all users, specifically, we need to know what e-mail addresses they have attached to the account
Write-Output "Getting list of users in Entra ID, this can take some time dependent on the number of accounts in the tenants."
$allusers = Get-MgUser -All -Property Id,mail,OtherMails,DisplayName,userPrincipalName

# change the domain data to an object
if($email_define_domains_for_owner_notification_email_enable -eq $true)
{
    $email_define_domains_for_owner_notification_email_object = @()
    $domainsplit = $email_define_domains_for_owner_notification_email.split(',')
    $domain_counter = 0
    foreach($domain in $domainsplit)
    {
        $domain_counter++
        $domain_type_priority = $null

        if($domain_counter -eq 1){$domain_type_priority = 'primary'}
        else{$domain_type_priority = 'secondary'}
        $prop = [ordered]@{
            domain                  = $domain
            domain_priority         = $domain_type_priority
            }
            $objcmddata = New-Object -TypeName psobject -Property $prop
            $email_define_domains_for_owner_notification_email_object += $objcmddata           
    }
}


<#
Used to notify the tenant admins by running the workflow that notifices about the generel state of expiring secrets and certiticates.
This function is used by all those other functions in the script, so please note: a change here will be a change to all messages except the ones send to SP owners
#>
function send_reports_to_governance_team {
    # Identify and index the storage account
    $storage_account_info = Get-AzStorageAccount -StorageAccountName $storage_account_temp_storage_account_name -ResourceGroupName $baseline_resource_group_name
    $storage_account_info_context = $storage_account_info.Context

    # Define The naming the files and operations for each export type
    
    $final_local_export_path = ".\" + $export_request_type + ".csv"

    $returndata | Export-Csv -path $final_local_export_path -Delimiter ';' -Encoding unicode

    $blob_upload = @{
        File             = $final_local_export_path
        Container        = $storage_account_container_name
        Blob             = $export_request_type + ".csv"
        Context          = $storage_account_info_context
        StandardBlobTier = 'Hot'
    }

    $exported_data_url = Set-AzStorageBlobContent @blob_upload -Force

    $export_properties = [ordered]@{
        sp_displayname                  = ""
        sp_id                           = ""
        secret_status                   = ""
        secret_expiry_eta               = ""
        secret_type                     = ""
        secret_Displayname              = ""
        secret_expiredDate              = ""
        secret_Startdate                = ""
        secret_hint                     = ""
        secret_text                     = ""
        owner_displayname               = ""
        owner_mail                      = $email_Contact_email_for_notification_emails
        owner_userprincipalname         = ""
        owner_id                        = ""
        tenant_name                     = ""
        tenant_id                       = $tenant_id
        request_type                    = $export_request_type
        blob_file_name                  = $export_request_type + ".csv"
        mail_subject                    = $export_file_name
        }
        $objcmddata = New-Object -TypeName psobject -Property $export_properties
        $exportdata += $objcmddata               


        $body = $exportdata | ConvertTo-Json
        Invoke-WebRequest -Uri $logic_app_url -Method POST -Body $body -ContentType 'application/json; charset=utf-16' 
}

<#
Pull the complete list of secrets and certificates that are about to expired, or already expired.
Both arrays will be used later in the script. 
#>
function get-all-expired-keys {
    $returndata = @()

    # Run through the list to verify secrets and expired certificates, right now, we are detecting what needs to reported
    foreach($sp in $App_registrations)
    {
        foreach($secret in $sp.PasswordCredentials)
        {
            $resource_expiration_date = get-date($secret.EndDateTime) # If the enddate is later than our limit, it will be added.
            
            # Check days until expiry
            $days_until_expired = $resource_expiration_date - $date_today
      
            if ($days_until_expired.Days -lt $secret_cert_days_to_expire) {

                # Note if secret is expired or currently active
                if($days_until_expired.days -lt 0)
                { $secret_status = "expired" }
                else {$secret_status = "Active - about to expire"}   

                $secret_properties = [ordered]@{
                    sp_displayname                      = $sp.DisplayName
                    sp_object_id                        = $sp.Id
                    sp_application_id                   = $sp.AppId
                    secret_type                         = "secret"
                    secret_status                       = $secret_status
                    secret_DisplayName                  = $secret.DisplayName
                    secret_EndDateTime                  = $secret.EndDateTime
                    secret_days_until_secret_expires    = $days_until_expired.days
                    secret_Hint                         = $secret.Hint
                    Secret_Text                         = $secret.SecretText
                    secret_Key                          = $secret.Key
                    secret_keyid                        = $secret.KeyId
                    secret_StartDateTime                = $secret.StartDateTime
                    tenant_id                           = $tenant_id
                    tenant_name                         = ""

                    }
                    $objcmddata = New-Object -TypeName psobject -Property $secret_properties
                    $returndata += $objcmddata     
            }
        }

        foreach($cert in $sp.KeyCredentials)
        {
            $resource_expiration_date = get-date($secret.EndDateTime) # If the enddate is later than our limit, it will be added.
            
            # Check days until expiry
            $days_until_expired = $resource_expiration_date - $date_today
            
            if ($days_until_expired.Days -lt $secret_cert_days_to_expire) {

                # Note if secret is expired or currently active
                if($days_until_expired.days -lt 0)
                { $secret_status = "expired" }
                else {$secret_status = "Active - about to expire"}  

                $certificate_properties = [ordered]@{
                    sp_displayname                      = $sp.DisplayName
                    sp_object_id                        = $sp.Id
                    sp_application_id                   = $sp.AppId
                    secret_type                         = "certificate"
                    secret_status                       = $secret_status
                    secret_DisplayName                  = $cert.DisplayName
                    secret_EndDateTime                  = $cert.EndDateTime
                    secret_days_until_secret_expires    = $days_until_expired.days
                    secret_Hint                         = $cert.Hint
                    Secret_Text                         = $cert.SecretText
                    secret_Key                          = $cert.Key
                    secret_keyid                        = $cert.KeyId
                    secret_StartDateTime                = $cert.StartDateTime
                    tenant_id                           = $tenant_id
                    tenant_name                         = ""

                    }
                    $objcmddata = New-Object -TypeName psobject -Property $certificate_properties
                    $returndata += $objcmddata     
            }
        }
    }
    return $returndata
}

function get_list_of_owners_for_expired_keys{

    <#
        Create an array containing all owners of the Service Principals with expired secrets and certificates
        For all Service Principals, where the owner is not registered, we will note "no_owner" in the value fields
        We will use this later to report these accounts to the governance team.
    #>

    $service_principal_list_of_owners = @()
    $trigger = 0 
    $total_number_off_Service_principals = $export_SP_data.count 
    foreach($keys in $export_SP_data)
    {
        $trigger++
        $application_name = $keys.sp_displayname
        
        $serviceprincipal_owners = Get-MgApplicationOwner -ApplicationId $keys.sp_object_id

        <#
            To have the data in a nicer format, we find the owners of each SP and attach these values
            to the object we crated earlier. 
            Each owner will be added seperately to an array so we have the data combined.
        #>
        if($serviceprincipal_owners.count -lt 1){
            $temp_owner = $null
            $temp_owner = $keys.PSObject.Copy()

            $temp_owner | Add-Member -NotePropertyName owner_displayname -NotePropertyValue "No_owner"
            $temp_owner | Add-Member -NotePropertyName owner_mail -NotePropertyValue "No_owner"
            $temp_owner | Add-Member -NotePropertyName owner_userprincipalname -NotePropertyValue "No_owner"
            $temp_owner | Add-Member -NotePropertyName owner_id -NotePropertyValue "No_owner"
            $temp_owner | Add-Member -NotePropertyName request_type -NotePropertyValue "single_user"
            $temp_owner | Add-Member -NotePropertyName blob_file_name -NotePropertyValue "NA"
            $temp_owner | Add-Member -NotePropertyName mail_subject -NotePropertyValue "NA"

            $service_principal_list_of_owners += $temp_owner
        }
        else {
            foreach($owner in $serviceprincipal_owners){
                $temp_owner = $null
                $Owner_email = $owner.AdditionalProperties.mail #Default value, will be overwritten if configured with approved e-mail domains
                $temp_owner = $keys.PSObject.Copy() #Copy the object to avoid powershell re-using the object
                $owner_lookup = $allusers | Where-Object {$_.UserPrincipalName -eq $owner.AdditionalProperties.userPrincipalName} #Lookup attributes for the user account
                $account_type = "single_user" #Default value for users, this will be changed if the domain whitelist is enabled

                # Combine e-mail addresses to array, this action will only be run if the email_define_domains_for_owner_notification_email_enable variable is set to true
                if($email_define_domains_for_owner_notification_email_enable -eq $true)
                {
                    # If enabled, we will look at all the e-mail addresses attached to a user accunt, and if the user have an e-mail address
                    # in an approved domain, we will send the notification e-mail to that address.

                    $account_type = "external_user" #Set as default due to domain whitelist being active. We will still save the user for the general notification mail
                    $all_email_addresses = @()
                    foreach($mail_Attribute in $owner_lookup.Mail){$all_email_addresses += $mail_Attribute}
                    foreach($mail_OtherMailAttribute in $owner_lookup.OtherMails){$all_email_addresses += $mail_OtherMailAttribute}         
                    
                    foreach($mail_address in $all_email_addresses)
                    {
                        $maildomain = $mail_address.split('@')[1]
                        if($email_define_domains_for_owner_notification_email_object.domain -contains $maildomain)
                        {
                            #If the user have an e-mail address in an approved domain, then the notification mail will be send to this address.
                            $Owner_email = $mail_address
                            $account_type = "single_user"
                            break
                        }
                    }
                }

                $temp_owner | Add-Member -NotePropertyName owner_displayname -NotePropertyValue $owner.AdditionalProperties.displayName 
                $temp_owner | Add-Member -NotePropertyName owner_mail -NotePropertyValue $Owner_email
                $temp_owner | Add-Member -NotePropertyName owner_userprincipalname -NotePropertyValue $owner.AdditionalProperties.userPrincipalName
                $temp_owner | Add-Member -NotePropertyName owner_id -NotePropertyValue $owner.id
                $temp_owner | Add-Member -NotePropertyName request_type -NotePropertyValue $account_type
                $temp_owner | Add-Member -NotePropertyName blob_file_name -NotePropertyValue "NA"
                $temp_owner | Add-Member -NotePropertyName mail_subject -NotePropertyValue "NA"

                $service_principal_list_of_owners += $temp_owner
            }
        }
    }
    return $service_principal_list_of_owners
}

function Send-email-to-users {  

    <# 
        Take the result of the expired keys, and inform the registered owners, if such owners exists and if the feature is enabled
    #>  
    $temp_expired_owners = @()
    $trigger = 0 
    $total_number_of_get_list_of_owners_for_expired_keys_ = $get_list_of_owners_for_expired_keys.count 
    Write-Output "Informing owners of expiring secrets"

    foreach($user in $get_list_of_owners_for_expired_keys)
    {
        $owner_name = $user.owner_displayname
        $secret_displayname = $user.sp_displayname
        $list_of_expired_secrets = $get_list_of_owners_for_expired_keys.count
        $secret_expires_eta = $user.secret_days_until_secret_expires
        $trigger++

        if($user.secret_status -eq "expired" -and $user.owner_mail -ne "No_owner" -and $user.request_type -ne "external_user") # If the secret is expired, we will send a notification on each run
        {
            $temp_expired_owners += $user
        }
        elseif ($user.owner_mail -eq "No_owner") {
            Write-Output "No owner found for secret  ($trigger/$list_of_expired_secrets)"
        }
        elseif ($email_inform_owners_days_with_warnings -notcontains $user.secret_days_until_secret_expires) 
        {
            Write-Output "ETA for expiration not within notification values. $owner_name have not been warned today about $secret_displayname in expiring in $secret_expires_eta days ($trigger/$list_of_expired_secrets)"
        }
        elseif($email_inform_owners_days_with_warnings -contains $user.secret_days_until_secret_expires -and $user.owner_mail -ne "No_owner" -and $user.request_type -ne "external_user") 
        {
            Write-Output "Notify $owner_name about secret on $secret_displayname in $secret_expires_eta days ($trigger/$list_of_expired_secrets)"
            $body = $user | ConvertTo-Json
            Invoke-WebRequest -Uri $logic_app_url -Method POST -Body $body -ContentType 'application/json; charset=utf-16'
        }
        else {
            write-error "Did not match any filters!: $secret_displayname ($trigger/$list_of_expired_secrets)"
        }        
    }

    foreach($user in $temp_expired_owners)
    {
        Write-Output "Notify $owner_name about expired secret on $secret_displayname ($trigger/$list_of_expired_secrets)"
        $body = $user | ConvertTo-Json
        Invoke-WebRequest -Uri $logic_app_url -Method POST -Body $body -ContentType 'application/json; charset=utf-16'
    }

    $test
}

function find_all_SP_with_expired_keys_and_secrets {

    <# 
        Search all Service principals for expired keys and secrets, and collect all of them in an array.
        This data will be send to the governance team if enabled.
    #>

    $returndata = @()

    foreach($secret in $get_list_of_owners_for_expired_keys)
    {  
        if ($secret.secret_status -eq "expired") 
        {
            $returndata += $secret
        }
    }

    $returndata = $returndata | Select-Object sp_displayname,sp_object_id,owner_userprincipalname,owner_mail,sp_application_id,secret_type,secret_status,secret_DisplayName,secret_StartDateTime,secret_EndDateTime,secret_days_until_secret_expires
    $export_request_type = "find_all_SP_with_expired_keys_and_secrets"
    $export_file_name = "Overview - all expired secrets and keys"
    send_reports_to_governance_team = $returndata, $export_file_name, $export_request_type | Out-Null
    return $returndata
}

function all_SPs_where_secret_is_about_to_expire {

    <# 
        Search all Service principals where the secrets and certs are about to expire and collect all of them in an array.
        This data will be send to the governance team if enabled.
    #>

    $returndata = @()

    foreach($secret in $get_list_of_owners_for_expired_keys)
    {  
        $secret | Select-Object DisplayName,secret_status
        if ($secret.secret_status -eq "Active - about to expire") 
        {
            $returndata += $secret
            $secret
        }
    }

    #$returndata = $returndata | Select-Object sp_displayname,sp_object_id,owner_userprincipalname,sp_application_id,secret_type,secret_status,secret_DisplayName,secret_StartDateTime,secret_EndDateTime,secret_days_until_secret_expires
    $export_request_type = "find_all_SPs_where_secret_is_about_to_expire"
    $export_file_name = "Overview - soon to expire secrets and certificates"
    send_reports_to_governance_team = $returndata, $export_file_name, $export_request_type
}

function get_list_of_orphaned_Service_Principals{

    <#
        Create an array containing all the Service principals that do NOT have an owner. It does not matter wether it uses a
        secret, certificate or federated authentication
    #>

    $returndata = @()
    foreach($key in $App_registrations)
    {
        $serviceprincipal_owners = Get-MgApplicationOwner -ApplicationId $key.id

        if($serviceprincipal_owners.count -lt 1){
            $sp_properties = [ordered]@{
                'Application (client) ID'   = $key.AppId
                DisplayName                 = $key.DisplayName
                'Object ID'                 = $key.id
                'secrets count'             = $key.PasswordCredentials.count
                'certificates count'        = $key.key.KeyCredentials.count
                }
                $objcmddata = New-Object -TypeName psobject -Property $sp_properties
                $returndata += $objcmddata     
        }
    }

    $export_request_type = "get_list_of_orphaned_Service_Principals"
    $export_file_name = "Overview - list_of_orphaned_Service_Principals"
    send_reports_to_governance_team = $returndata, $export_file_name, $export_request_type
}

# Get a list of all expired keys
$timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
Write-Output "Now getting all expired keys - time elapsed $timespend"
$export_SP_data = get-all-expired-keys
$found_SP_data_count = $export_SP_data.count
$timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
Write-Output "Found $found_SP_data_count expired key - time elapsed $timespend"


# Get a list of owners for all expired keys
$timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
Write-Output "Now getting a list of all registered owners of service principals with expired secrets and certificates - time elapsed $timespend"
$get_list_of_owners_for_expired_keys = get_list_of_owners_for_expired_keys
$get_list_of_owners_for_expired_keys_count = $get_list_of_owners_for_expired_keys.count
$timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
Write-Output "Found $get_list_of_owners_for_expired_keys_count of owners - time elapsed $timespend"


# if enabled, it will send an overview to the registered notification e-mail about all service principals with expired secrets and certificated
if ($email_Contact_email_for_all_SPs_with_expired_secrets_status -eq $true) 
{   
    $timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
    Write-Output "Notifying notification address about all expired secrets and certificates  - time elapsed $timespend"
    $export_all_SP_with_expired_keys_and_secrets = find_all_SP_with_expired_keys_and_secrets 
}

# If enabled, it will send an overview to the registered notification e-mail about all service principals that have secrets or certificates
# that are about to expire
if ($email_Contact_email_for_all_SPs_where_secret_is_about_to_expire -eq $true) 
{ 
    $timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
    Write-Output "Notifying notification address about all secrets and certificates that are about to expire - time elapsed $timespend"
    $export_all_SPs_where_secret_is_about_to_expire  = all_SPs_where_secret_is_about_to_expire 
}

# If enabled, it will send an overview to the registered notification e-mail about all service principals that doesen't contain an owner
if ($email_Contact_email_get_list_of_orphaned_Service_Principals -eq $true) 
{ 
    $timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
    Write-Output "Notifying notification address about all orphaned service principals - time elapsed $timespend"
    $export_get_list_of_orphaned_Service_Principals  = get_list_of_orphaned_Service_Principals 
}

# If enabled, it will send an e-mail to all registered owners of a Service Principal
if ($email_inform_owners_directly -eq $true) 
    { 
    $timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
    $get_list_of_owners_for_expired_keys_count = $get_list_of_owners_for_expired_keys.count
    Write-Output "Informing owners about expiring secrets and certificates - List contains $get_list_of_owners_for_expired_keys_count - time elapsed $timespend"
    $serviceprincipal_owner_expanded = Send-email-to-users # Email users if enabled
    Write-Output "tried to inform all owners, please check Logic app for result - time elapsed $timespend"
    } 

Clear-AzContext -Confirm:$false
Disconnect-MgGraph