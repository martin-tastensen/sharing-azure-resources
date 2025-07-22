<#
.COPYRIGHT
Copyright (c) MMT Consult. All rights reserved. Licensed under the MIT license.
See LICENSE in the project root for license information.

Version 1.0.0
Author: Martin Meiner Tästensen
contact: support@mmt-consult.dk
#>

Param(
    [parameter(mandatory = $true, HelpMessage = "Provide tenantid for the specific tenant")] 
    [string]$tenantid,

    [parameter(mandatory = $false, HelpMessage = "Path for CSV export file - default path is: C:\Temp\empty vnet list.csv")] 
    [string]$exportpath = $false,

    [parameter(mandatory = $false, HelpMessage = "change to false if you don't want it to open the result in a browser")] 
    [string]$openbrowser = $true
)

# Verify if a connection to the expected tenant already exists, and if not create it.
$connection = Get-AzContext
if($connection.Tenant.id -eq $tenantid)
{
    write-host "Already connected to the correct tenant, no further action nessesary" -ForegroundColor green
}
else{Connect-AzAccount -Tenant $tenantid}

$Query = '
Resources
| where type == "microsoft.network/publicipaddresses"
| extend ipsku = sku.name
| extend public_ip = name
| extend IpAddress = properties.ipAddress
| extend attachedTo = properties.ipConfiguration.id
| extend attachedRG = extract("/resourceGroups/([^/]+)", 1, tostring(attachedTo))
| extend attachedType = extract("/providers/Microsoft.Network/([^/]+)", 1, tostring(attachedTo))
| extend attachedName = extract("/providers/.+?/.+?/(.+?)/", 1, tostring(attachedTo))
| where ipsku == "Basic"
| project public_ip, IpAddress, ipsku, location, resourceGroup, subscriptionId,attachedName, attachedRG,attachedType,attachedTo
'

$data = Search-AzGraph -Query $query 

if($openbrowser -eq $true)
{
$datatable = $data | Select-Object public_ip, IpAddress, ipsku, location, resourceGroup, subscriptionId, attachedName, attachedRG, attachedType, attachedTo

    # CSS to make it atleast decent looking
    $css = @'
<style>
    body {
        font-family: Segoe UI, sans-serif;
        padding: 20px;
    }
    h1 {
        font-size: 1.5em;
        margin-bottom: 20px;
    }
    table {
        border-collapse: collapse;
        width: 100%;
        margin-top: 10px;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px 12px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
        font-weight: bold;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
</style>
'@

    $html = $datatable | ConvertTo-Html -Title "Azure Public IPs" -PreContent "<h1>Liste over Basic Public IPs</h1>" | Out-String
    $html = $css + $html

    $tempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$(New-Guid).html")
    Set-Content -Path $tempFile -Value $html -Encoding UTF8

    # Open result in Browser.
    if ($IsWindows) {
        Start-Process $tempFile
    } elseif ($IsMacOS) {
        & open $tempFile
    } elseif ($IsLinux) {
        & xdg-open $tempFile
    }
}

if ($exportpath -ne $false) {
    $datatable | Export-Csv -Path $exportpath -Delimiter ';' -Encoding unicode -NoTypeInformation
}