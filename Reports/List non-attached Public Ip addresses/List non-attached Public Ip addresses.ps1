<#
.COPYRIGHT
Copyright (c) MMT Consult. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.

Version 0.0.1
Author: Martin Meiner Tästensen
contact: support@mmt-consult.dk
#>

Param(
    [parameter(mandatory = $false, HelpMessage = "Provide subscription id to only verify the specific subscription")] 
    [string]$subscriptionId = $null,

    [parameter(mandatory = $false, HelpMessage = "Provide subscription name to only verify the specific subscription")] 
    [string]$subscriptionName = $null,

    [parameter(mandatory = $true, HelpMessage = "Provide tenantid for the specific tenant")] 
    [string]$tenantid,

    [parameter(mandatory = $false, HelpMessage = "Path for CSV export file")] 
    [string]$exportpath = "C:\Temp\non-attached Public IP addresses.csv"
)

# Verify if a connection to the expected tenant already exists, and if not create it.
$connection = Get-AzContext
if($connection.Tenant.id -eq $tenantid)
{
    write-host "Already connected to the correct tenant, no further action nessesary" -ForegroundColor green
}
else{Connect-AzAccount -Tenant $tenantid}


# Dependent on choice for parameters, get data for all subscriptions or only the one selected
if([string]::IsNullOrWhiteSpace($subscriptionId) -or [string]::IsNullOrWhiteSpace($subscriptionName))
{
    $subscriptions = Get-AzSubscription -TenantId $tenantid
}
elseif ([string]::IsNullOrWhiteSpace($subscriptionId)) 
{
    $subscriptions = Get-AzSubscription -TenantId $tenantid -SubscriptionId $subscriptionId
}
elseif ([string]::IsNullOrWhiteSpace($subscriptionName)) 
{
    $subscriptions = Get-AzSubscription -TenantId $tenantid -SubscriptionName $subscriptionName
}

<#
    Run through each subscription, and pull the data required to verify the all public ip addresses.
    This process can take some time, depending on the amount of PIP's and subscriptions.
    The data will be saved into a new object.
#>

$totalpublicIP = @()
$notusedPIP = @()
$usedPIP = @()

foreach($subscription in $subscriptions)
{
    $connecttosubscription = Select-AzSubscription -Tenant $tenantid -Subscription $subscription.Id
    
    $temppubliciplist = Get-AzPublicIpAddress

    foreach($publicip in $temppubliciplist)
    {
        $p = @{
            PIPName                                = $publicip.Name
            PIPResourceGroupName                   = $publicip.ResourceGroupName
            PIPLocation                            = $publicip.Location
            PIPPublicIpAllocationMethod            = $publicip.PublicIpAllocationMethod
            PIPIpAddress                           = $publicip.IpAddress
            PIPPublicIpAddressVersion              = $publicip.PublicIpAddressVersion
            PIPIdleTimeoutInMinutes                = $publicip.IdleTimeoutInMinutes
            PIPIpConfiguration                     = $publicip.IpConfiguration.Id
            PIPDnsSettings                         = $publicip.DnsSettings -join ',' 
            PIPSkuName                             = $publicip.Sku.Name
            PIPSkuTier                             = $publicip.Sku.Tier
            subscriptionName                    = $subscription.Name
            subscriptionId                      = $subscription.Id
            tenantid                            = $subscription.TenantId
    
            }
            $objcmddata = New-Object -TypeName psobject -Property $p
            $totalpublicIP += $objcmddata
    }
}

<#
    Verifying if the IP address is attached to a network card. This can be both a classic network
    card or LB

    All resources that are not attached will be exported to a CSV file
#>
foreach($pip in $totalpublicIP)
{
    if([string]::IsNullOrWhiteSpace($pip.PIPIpConfiguration)) 
    {
        $notusedPIP += $pip
    }
    else {
        $usedPIP += $pip 
    }
}

<#
    Export to a CSV containing all non-attached Public Ip addresses
#>
$notusedPIP | `
Select-Object PIPName,PIPResourceGroupName,subscriptionName,PIPLocation,PIPSkuName,PIPSkuTier,PIPIpAddress,tenantid, `
PIPDnsSettings,PIPIpConfiguration,PIPPublicIpAddressVersion,PIPIdleTimeoutInMinutes,PIPPublicIpAllocationMethod,subscriptionId | `
Export-Csv -Path $exportpath -Delimiter ';' -Encoding unicode -NoTypeInformation

write-host "Script is completed, please find the export file at $exportpath" -ForegroundColor green