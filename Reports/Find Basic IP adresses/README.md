# Azure Basic Public IP Inventory Script

This PowerShell script queries Azure Resource Graph to extract an overview of all basic ip addresses across a given tenant. <br>
The result will by default be exportet to a HTML file that will be opened, or can alternatively be exported to a CSV (or both)

---

## Features

- Queries all `Basic` Public IP addresses using Azure Resource Graph (ARG)
- Optionally, but by default opens the result in a webbrowser (disable with the **-openbrowser $false** flag)
- Optionally, can export the result to a CSV File. (enable by defining a save path with the **-exportpath "C:\Temp\basic_public_ips.csv"** flag)

Will extract the following information:
- public_ip
- IpAddress
- Ipsku
- location
- resourceGroup
- subscriptionId
- attachedName
- attachedRG
- attachedType
- attachedTo

**NOTE**: This script will only export the data on subscriptions where the user running it has reader or above permissions

---

## Prerequisites and tested with

- PowerShell 7+ (recommended, should work on powershell 6 as well)
- Modules:
  - AZ
- Access to the specified tenant (via `Connect-AzAccount`)

---

## Usage

values in [] are optional
```powershell
.\Find_Basic_IP_addresses.ps1 -tenantid "<your-tenant-id>" [-exportpath "C:\Temp\basic_public_ips.csv"(default $false)] [-openbrowser $false(default $true)]
