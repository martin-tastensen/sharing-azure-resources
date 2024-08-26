<#
.COPYRIGHT
Copyright (c) MMT Consult. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.

Version 0.0.10
Author: Martin Meiner Tästensen
contact: support@mmt-consult.dk
#>

$tenant_id = "105f1023-7c86-4358-935f-b167313506fb"
$subscription_id = "cb83e8c8-dcdd-4d25-8449-e727bd23b0f3"
$application_id = "63d641ce-51ea-4846-b501-a1a111e50e66"
$secret_cert_days_to_expire = "30"
$key_vault_resource_name = "mts-keyvault-test-n"
$key_vault_secret_key_name = "key-vault-expiry-n"
$logic_app_url = "https://prod-30.swedencentral.logic.azure.com:443/workflows/fc8668c1be354f568caeac5f48e2e723/triggers/When%20a%20HTTP%20request%20is%20received/paths/invoke?api-version=2019-05-01&sp=%2Ftriggers%2FWhen%20a%20HTTP%20request%20is%20received%2Frun&sv=1.0&sig=d_aO_pWjlHPVCF59pmhBYFgUbb-xZ2SlcaI5NLvvpG8"
$storage_account_container_name = "temp-storage"
$storage_account_temp_storage_account_name = "lqxniyjubdstjzro"
$baseline_resource_group_name = "mts-secret-test-rg-n"
$temp_export_path = "/Users/martintastensen/temp/"
$email_inform_owners_directly = "disabled"
$email_inform_owners_days_with_warnings = "1,2,3,4,5,6,7,14,21,28,30"
$email_Contact_email_for_all_SPs_with_expired_secrets_status = "disabled"
$email_Contact_email_for_all_SPs_where_secret_is_about_to_expire = "disabled"
$email_Contact_email_for_notification_emails = "martin@tastensen.dk"
$email_Contact_email_get_list_of_orphaned_Service_Principals = "enabled"

#########################################
# Sign-in with system assigned identity # 
#########################################

# process borrowed from MS learn:
# https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation#authenticate-access-with-system-assigned-managed-identity

# Connect to Azure with system-assigned managed identity
#$AzureContext = (Connect-AzAccount -Subscription $subscription_id -Tenant $tenant_id -Identity).context

Connect-AzAccount -Subscription $subscription_id -Tenant $tenant_id


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
$App_registrations = Get-MgApplication -All -Property Id,DisplayName,AppId,AdditionalProperties,PasswordCredentials,keyCredentials

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
        tenant_id                       = ""
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

$export_SP_data = get-all-expired-keys

<#
Create an array containing all owners of the Service Principals with expired secrets and certificates
For all Service Principals, where the owner is not registered, we will note "no_owner" in the value fields
We will use this later to report these accounts to the governance team.
#>
function get_list_of_owners_for_expired_keys{
    
    $serviceprincipal_no_owner_expanded = @()
    $serviceprincipal_owner_expanded = @()
    foreach($keys in $export_SP_data)
    {
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

            $serviceprincipal_no_owner_expanded += $temp_owner
        }
        else {
            foreach($owner in $serviceprincipal_owners){
                $temp_owner = $null
                $temp_owner = $keys.PSObject.Copy()

                $temp_owner | Add-Member -NotePropertyName owner_displayname -NotePropertyValue $owner.AdditionalProperties.displayName 
                $temp_owner | Add-Member -NotePropertyName owner_mail -NotePropertyValue $owner.AdditionalProperties.mail
                $temp_owner | Add-Member -NotePropertyName owner_userprincipalname -NotePropertyValue $owner.AdditionalProperties.userPrincipalName
                $temp_owner | Add-Member -NotePropertyName owner_id -NotePropertyValue $owner.id
                $temp_owner | Add-Member -NotePropertyName request_type -NotePropertyValue "single_user"
                $temp_owner | Add-Member -NotePropertyName blob_file_name -NotePropertyValue "NA"
                $temp_owner | Add-Member -NotePropertyName mail_subject -NotePropertyValue "NA"

                $serviceprincipal_owner_expanded += $temp_owner
            }
        }
    }
    return $serviceprincipal_owner_expanded, $serviceprincipal_no_owner_expanded
}

$get_list_of_owners_for_expired_keys = get_list_of_owners_for_expired_keys
$serviceprincipal_owner_expanded = $get_list_of_owners_for_expired_keys[0].PSObject.Copy()
$serviceprincipal_no_owner_expanded = $get_list_of_owners_for_expired_keys[1].PSObject.Copy()


<# 
Take the result of the expired keys, and inform the registered owners, if such owners exists and if the feature is enabled
#>
function Send-email-to-users {  
    foreach($user in $serviceprincipal_owner_expanded)
    {
        if($user.secret_status -eq "expired")
        {
            Write-Output $user | ConvertTo-Json
            $body = $user | ConvertTo-Json
            Invoke-WebRequest -Uri $logic_app_url -Method POST -Body $body -ContentType 'application/json; charset=utf-16'
        }
        else {
            foreach($day in $email_inform_owners_days_with_warnings.split(','))
            { 
                if($day -like $user.secret_days_until_secret_expires)
                {
                    Write-Output $user | ConvertTo-Json
                    $body = $user | ConvertTo-Json
                    Invoke-WebRequest -Uri $logic_app_url -Method POST -Body $body -ContentType 'application/json; charset=utf-16'
                }
            }
        }        
    }
}

if ($email_inform_owners_directly -eq $true) { $serviceprincipal_owner_expanded = Send-email-to-users } # Email users if enabled


<# 
Search all Service principals for expired keys and secrets, and collect all of them in an array.
This data will be send to the governance team if enabled.
#>
function find_all_SP_with_expired_keys_and_secrets {
    $returndata = @()

    foreach($secret in $serviceprincipal_owner_expanded)
    {  
        if ($secret.secret_status -eq "expired") 
        {
            $returndata += $secret
        }

    }
    foreach($secret in $serviceprincipal_no_owner_expanded)
    {        
        if ($secret.secret_status -eq "expired") 
        {
        $returndata += $secret
        }
    }


    $returndata = $returndata | Select-Object sp_displayname,sp_object_id,owner_userprincipalname,sp_application_id,secret_type,secret_status,secret_DisplayName,secret_StartDateTime,secret_EndDateTime,secret_days_until_secret_expires
    $export_request_type = "find_all_SP_with_expired_keys_and_secrets"
    $export_file_name = "Overview - all expired secrets and keys"
    send_reports_to_governance_team = $returndata, $export_file_name, $export_request_type
}

if ($email_Contact_email_for_all_SPs_with_expired_secrets_status -eq $true) { $export_all_SP_with_expired_keys_and_secrets = find_all_SP_with_expired_keys_and_secrets }

<# 
Search all Service principals where the secrets and certs are about to expire and collect all of them in an array.
This data will be send to the governance team if enabled.
#>
function all_SPs_where_secret_is_about_to_expire {
    $returndata = @()

    foreach($secret in $serviceprincipal_owner_expanded)
    {  
        if ($secret.secret_status -eq "Active - about to expire") 
        {
            $returndata += $secret
        }

    }
    foreach($secret in $serviceprincipal_no_owner_expanded)
    {        
        if ($secret.secret_status -eq "Active - about to expire") 
        {
        $returndata += $secret
        }
    }
    $returndata = $returndata | Select-Object sp_displayname,sp_object_id,owner_userprincipalname,sp_application_id,secret_type,secret_status,secret_DisplayName,secret_StartDateTime,secret_EndDateTime,secret_days_until_secret_expires
    $export_request_type = "find_all_SPs_where_secret_is_about_to_expire"
    $export_file_name = "Overview - soon to expire secrets and certificates"
    send_reports_to_governance_team = $returndata, $export_file_name, $export_request_type
}

if ($email_Contact_email_for_all_SPs_where_secret_is_about_to_expire -eq $true) { $export_all_SPs_where_secret_is_about_to_expire  = all_SPs_where_secret_is_about_to_expire }

<#
Create an array containing all the Service principals that do NOT have an owner. It does not matter wether it uses a
secret, certificate or federated authentication
#>
function get_list_of_orphaned_Service_Principals{
    $returndata = @()
    $test
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

if ($email_Contact_email_get_list_of_orphaned_Service_Principals -eq $true) { $export_get_list_of_orphaned_Service_Principals  = get_list_of_orphaned_Service_Principals }
