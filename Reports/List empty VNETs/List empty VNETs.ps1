<#
.COPYRIGHT
Copyright (c) MMT Consult. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.

Version 0.0.2
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
    [string]$exportpath = "C:\Temp\empty vnet list.csv",

    [parameter(mandatory = $false, HelpMessage = "define if the export is based on subnet or vnet")] 
    [validateset("simple","full")]
    [string]$exportdetail = "full"
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

# Creationg of the arrays that will be used later in the script
$vnetexport = @()
$emptyvnets = @()
$notemptyvnets = @()
$usedvnets = @()

<#
    Run through each subscription, and pull the data required to verify the vnet.
    This process can take some time, depending on the amount of VNET's and subscriptions.
    The data will be saved into a new object, that will be based on subnets.
#>
foreach($subscription in $subscriptions)
{
    $connecttosubscription = Select-AzSubscription -Tenant $tenantid -Subscription $subscription.Id
    
    $virtualnetworks = Get-AzVirtualNetwork

    foreach($virtualnetwork in $virtualnetworks)
    {
        $subnetvnetlist = @()
        foreach($subnet in $virtualnetwork.subnets.name)
        {
            $subnetvnetlist += Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualnetwork -Name $subnet
        }

        foreach($i in $subnetvnetlist)
        {
            $p = @{
                VNETname                            = $virtualnetwork.Name
                VNETRessourcegroup                  = $virtualnetwork.ResourceGroupName
                VNETLocation                        = $virtualnetwork.Location
                VNETId                              = $virtualnetwork.Id -join ',' 
                VNETResourceGuid                    = $virtualnetwork.ResourceGuid
                subscriptionName                    = $subscription.Name
                subscriptionId                      = $subscription.Id
                tenantid                            = $subscription.TenantId
                subnetname                          = $i.Name
                subnetid                            = $i.Id -join ',' 
                subnetIPconfig                      = $i.IpConfigurations.id -join ',' 
                subnetResourceNavigationLinks       = $i.ResourceNavigationLinks  -join ',' 
                subnetServiceAssociationLinks       = $i.ServiceAssociationLinks.id -join ',' 
                subnetNetworkSecurityGroup          = $i.NetworkSecurityGroup
                subnetRouteTable                    = $i.RouteTable
                subnetNatGateway                    = $i.NatGateway
                subnetServiceEndpoints              = $i.ServiceEndpoints.service -join ',' 
                subnetServiceEndpointPolicies       = $i.ServiceEndpointPolicies -join ',' 
                subnetPrivateEndpoints              = $i.PrivateEndpoints.id -join ',' 
                subnetEndpointNetworkPolicies       = $i.EndpointNetworkPolicies
                subnetLinkServiceNetworkPolicies    = $i.LinkServiceNetworkPolicies -join ',' 
                }
                $objcmddata = New-Object -TypeName psobject -Property $p
                $vnetexport += $objcmddata
        }
    }    
}

<#
    Verify if the vnet's are empty. It will have to run through each subnet multiple times
    since each subnet are saved in the same entry. No calls are required for this part, so 
    it will go fairly quickly
#>
foreach($resource in $vnetexport)
{
    if($usedvnets.VNETID -notcontains $resource.VNETID)
    {
        $tempvalue = @()
        $usedvnets += $resource

        foreach($i in $vnetexport)
        {
            if($i.VNETID -eq $resource.VNETID)
            {
                $tempvalue += $i
            }            
        }
        if([string]::IsNullOrWhiteSpace($tempvalue.subnetIPconfig) -and `
        [string]::IsNullOrWhiteSpace($tempvalue.subnetServiceEndpointPolicies) -and `
        [string]::IsNullOrWhiteSpace($tempvalue.subnetLinkServiceNetworkPolicies) -and `
        [string]::IsNullOrWhiteSpace($tempvalue.subnetServiceEndpoints) -and `
        [string]::IsNullOrWhiteSpace($tempvalue.subnetServiceAssociationLinks) -and `
        [string]::IsNullOrWhiteSpace($tempvalue.subnetPrivateEndpoints)) 
        {
            $emptyvnets += $tempvalue
        }
        else {
            $notemptyvnets += $tempvalue 
        }
    }
}

<#
    Export the data to CSV.
    Note: This data can be based on either the VNET or subnet, dependent on your wishes
#>

if($exportdetail -eq "simple")
{
    $emptyvnets | `
    Select-Object VNETname, VNETRessourcegroup, VNETLocation, VNETResourceGuid, subscriptionName, subnetname | `
    Export-Csv -Path $exportpath -Delimiter ';' -Encoding unicode -NoTypeInformation
}
elseif($exportdetail -eq "full")
{
    $emptyvnets | `
    Select-Object VNETname, VNETRessourcegroup, VNETLocation, VNETResourceGuid, subscriptionName, subnetname, subnetIPconfig, `
    subnetResourceNavigationLinks, subnetServiceAssociationLinks, subnetNetworkSecurityGroup, subnetRouteTable, `
    subnetNatGateway, subnetServiceEndpoints, subnetServiceEndpointPolicies, subnetPrivateEndpoints, `
    subnetEndpointNetworkPolicies, subnetLinkServiceNetworkPolicies, tenantid, VNETId, subscriptionId, subnetid | `
    Export-Csv -Path $exportpath -Delimiter ';' -Encoding unicode -NoTypeInformation
}

write-host "Script is completed, please find the export file at $exportpath" -ForegroundColor green