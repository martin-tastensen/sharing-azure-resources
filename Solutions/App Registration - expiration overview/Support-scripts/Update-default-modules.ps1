$tenant_id = Get-AutomationVariable -Name tenant_id
$subscription_id = Get-AutomationVariable -Name subscription_id
$automationaccountname = Get-AutomationVariable -Name automation_account_solution_name
$resourcegroup = Get-AutomationVariable -Name baseline_resource_group_name

#########################################
# Sign-in with system assigned identity # 
#########################################
$stopwatch = [system.diagnostics.stopwatch]::StartNew()

# process borrowed from MS learn:
# https://learn.microsoft.com/en-us/azure/automation/enable-managed-identity-for-automation#authenticate-access-with-system-assigned-managed-identity

$timespend = $stopwatch.Elapsed.Minutes.ToString() + ":" + $stopwatch.Elapsed.seconds.ToString()
Write-Output "Connecting to Azure, using system managed account - time elapsed $timespend"

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Subscription $subscription_id -Tenant $tenant_id -Identity).context

# Set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription

$allmodules = @()

$ModuleList = @(@{ModuleName = 'Az.Accounts'; RequiredVersion = '3.0.4'; }, 
               @{ModuleName = 'Az.Advisor'; RequiredVersion = '2.0.1'; }, 
               @{ModuleName = 'Az.Aks'; RequiredVersion = '6.0.4'; }, 
               @{ModuleName = 'Az.AnalysisServices'; RequiredVersion = '1.1.5'; }, 
               @{ModuleName = 'Az.ApiManagement'; RequiredVersion = '4.0.4'; }, 
               @{ModuleName = 'Az.App'; RequiredVersion = '1.0.1'; }, 
               @{ModuleName = 'Az.AppConfiguration'; RequiredVersion = '1.3.2'; }, 
               @{ModuleName = 'Az.ApplicationInsights'; RequiredVersion = '2.2.5'; }, 
               @{ModuleName = 'Az.ArcResourceBridge'; RequiredVersion = '1.0.1'; }, 
               @{ModuleName = 'Az.Attestation'; RequiredVersion = '2.0.2'; }, 
               @{ModuleName = 'Az.Automanage'; RequiredVersion = '1.0.2'; }, 
               @{ModuleName = 'Az.Automation'; RequiredVersion = '1.10.0'; }, 
               @{ModuleName = 'Az.Batch'; RequiredVersion = '3.6.3'; }, 
               @{ModuleName = 'Az.Billing'; RequiredVersion = '2.0.4'; }, 
               @{ModuleName = 'Az.Cdn'; RequiredVersion = '3.2.2'; }, 
               @{ModuleName = 'Az.CloudService'; RequiredVersion = '2.0.1'; }, 
               @{ModuleName = 'Az.CognitiveServices'; RequiredVersion = '1.14.1'; }, 
               @{ModuleName = 'Az.Compute'; RequiredVersion = '8.3.0'; }, 
               @{ModuleName = 'Az.ConfidentialLedger'; RequiredVersion = '1.0.1'; }, 
               @{ModuleName = 'Az.ContainerInstance'; RequiredVersion = '4.0.2'; }, 
               @{ModuleName = 'Az.ContainerRegistry'; RequiredVersion = '4.2.1'; }, 
               @{ModuleName = 'Az.CosmosDB'; RequiredVersion = '1.14.5'; }, 
               @{ModuleName = 'Az.DataBoxEdge'; RequiredVersion = '1.1.1'; }, 
               @{ModuleName = 'Az.Databricks'; RequiredVersion = '1.9.0'; }, 
               @{ModuleName = 'Az.DataFactory'; RequiredVersion = '1.18.7'; }, 
               @{ModuleName = 'Az.DataLakeAnalytics'; RequiredVersion = '1.0.3'; }, 
               @{ModuleName = 'Az.DataLakeStore'; RequiredVersion = '1.3.2'; }, 
               @{ModuleName = 'Az.DataProtection'; RequiredVersion = '2.4.0'; }, 
               @{ModuleName = 'Az.DataShare'; RequiredVersion = '1.0.2'; }, 
               @{ModuleName = 'Az.DesktopVirtualization'; RequiredVersion = '4.3.1'; }, 
               @{ModuleName = 'Az.DevCenter'; RequiredVersion = '1.2.0'; }, 
               @{ModuleName = 'Az.DevTestLabs'; RequiredVersion = '1.0.3'; }, 
               @{ModuleName = 'Az.Dns'; RequiredVersion = '1.2.1'; }, 
               @{ModuleName = 'Az.DnsResolver'; RequiredVersion = '1.0.0'; }, 
               @{ModuleName = 'Az.ElasticSan'; RequiredVersion = '1.0.3'; }, 
               @{ModuleName = 'Az.EventGrid'; RequiredVersion = '2.0.0'; }, 
               @{ModuleName = 'Az.EventHub'; RequiredVersion = '5.0.0'; }, 
               @{ModuleName = 'Az.FrontDoor'; RequiredVersion = '1.11.1'; }, 
               @{ModuleName = 'Az.Functions'; RequiredVersion = '4.1.0'; }, 
               @{ModuleName = 'Az.HDInsight'; RequiredVersion = '6.2.0'; }, 
               @{ModuleName = 'Az.HealthcareApis'; RequiredVersion = '2.0.1'; }, 
               @{ModuleName = 'Az.IotHub'; RequiredVersion = '2.7.7'; }, 
               @{ModuleName = 'Az.KeyVault'; RequiredVersion = '6.1.0'; }, 
               @{ModuleName = 'Az.Kusto'; RequiredVersion = '2.3.1'; }, 
               @{ModuleName = 'Az.LoadTesting'; RequiredVersion = '1.0.1'; }, 
               @{ModuleName = 'Az.LogicApp'; RequiredVersion = '1.5.1'; }, 
               @{ModuleName = 'Az.MachineLearning'; RequiredVersion = '1.1.4'; }, 
               @{ModuleName = 'Az.MachineLearningServices'; RequiredVersion = '1.1.0'; }, 
               @{ModuleName = 'Az.Maintenance'; RequiredVersion = '1.4.3'; }, 
               @{ModuleName = 'Az.ManagedServiceIdentity'; RequiredVersion = '1.2.1'; }, 
               @{ModuleName = 'Az.ManagedServices'; RequiredVersion = '3.0.1'; }, 
               @{ModuleName = 'Az.MarketplaceOrdering'; RequiredVersion = '2.0.1'; }, 
               @{ModuleName = 'Az.Media'; RequiredVersion = '1.1.2'; }, 
               @{ModuleName = 'Az.Migrate'; RequiredVersion = '2.4.0'; }, 
               @{ModuleName = 'Az.Monitor'; RequiredVersion = '5.2.1'; }, 
               @{ModuleName = 'Az.MySql'; RequiredVersion = '1.2.1'; }, 
               @{ModuleName = 'Az.Network'; RequiredVersion = '7.8.1'; }, 
               @{ModuleName = 'Az.NetworkCloud'; RequiredVersion = '1.0.2'; }, 
               @{ModuleName = 'Az.Nginx'; RequiredVersion = '1.1.0'; }, 
               @{ModuleName = 'Az.NotificationHubs'; RequiredVersion = '1.1.3'; }, 
               @{ModuleName = 'Az.OperationalInsights'; RequiredVersion = '3.2.1'; }, 
               @{ModuleName = 'Az.Oracle'; RequiredVersion = '1.0.0'; }, 
               @{ModuleName = 'Az.PolicyInsights'; RequiredVersion = '1.6.5'; }, 
               @{ModuleName = 'Az.PostgreSql'; RequiredVersion = '1.1.2'; }, 
               @{ModuleName = 'Az.PowerBIEmbedded'; RequiredVersion = '2.0.0'; }, 
               @{ModuleName = 'Az.PrivateDns'; RequiredVersion = '1.0.5'; }, 
               @{ModuleName = 'Az.RecoveryServices'; RequiredVersion = '7.1.0'; }, 
               @{ModuleName = 'Az.RedisCache'; RequiredVersion = '1.10.0'; }, 
               @{ModuleName = 'Az.RedisEnterpriseCache'; RequiredVersion = '1.2.1'; }, 
               @{ModuleName = 'Az.Relay'; RequiredVersion = '2.0.1'; }, 
               @{ModuleName = 'Az.ResourceGraph'; RequiredVersion = '1.0.0'; }, 
               @{ModuleName = 'Az.ResourceMover'; RequiredVersion = '1.2.1'; }, 
               @{ModuleName = 'Az.Resources'; RequiredVersion = '7.4.0'; }, 
               @{ModuleName = 'Az.Security'; RequiredVersion = '1.7.0'; }, 
               @{ModuleName = 'Az.SecurityInsights'; RequiredVersion = '3.1.2'; }, 
               @{ModuleName = 'Az.ServiceBus'; RequiredVersion = '4.0.0'; }, 
               @{ModuleName = 'Az.ServiceFabric'; RequiredVersion = '3.3.4'; }, 
               @{ModuleName = 'Az.SignalR'; RequiredVersion = '2.0.2'; }, 
               @{ModuleName = 'Az.Sql'; RequiredVersion = '5.3.0'; }, 
               @{ModuleName = 'Az.SqlVirtualMachine'; RequiredVersion = '2.3.1'; }, 
               @{ModuleName = 'Az.StackHCI'; RequiredVersion = '2.4.0'; }, 
               @{ModuleName = 'Az.StackHCIVM'; RequiredVersion = '1.0.4'; }, 
               @{ModuleName = 'Az.Storage'; RequiredVersion = '7.3.0'; }, 
               @{ModuleName = 'Az.StorageMover'; RequiredVersion = '1.4.0'; }, 
               @{ModuleName = 'Az.StorageSync'; RequiredVersion = '2.3.1'; }, 
               @{ModuleName = 'Az.StreamAnalytics'; RequiredVersion = '2.0.1'; }, 
               @{ModuleName = 'Az.Support'; RequiredVersion = '2.0.0'; }, 
               @{ModuleName = 'Az.Synapse'; RequiredVersion = '3.0.10'; }, 
               @{ModuleName = 'Az.TrafficManager'; RequiredVersion = '1.2.2'; }, 
               @{ModuleName = 'Az.Websites'; RequiredVersion = '3.2.1'; },
               @{ModuleName = 'Az'; RequiredVersion = '12.3.0'; }
)

foreach($i in $ModuleList)
{
    $baselineurl = "https://psg-prod-eastus.azureedge.net/packages/"
    $baselineDocumentationuri = "https://www.powershellgallery.com/packages/"
    $modulename = $i.ModuleName
    $moduleversion = $i.RequiredVersion
    $modulename_lower = $modulename.ToLower()
    $module_url = $baselineurl + $modulename_lower + "." + $moduleversion + ".nupkg"
    $documentationurl = $baselineDocumentationuri + $modulename_lower
    
    $export_properties =  @{
        module = $modulename
        version = $moduleversion
        url = $module_url
        documentation = $documentationurl
    }
    $objcmddata = New-Object -TypeName psobject -Property $export_properties
    $allmodules += $objcmddata
}

$trigger = 0
foreach($i in $allmodules)
{
    $trigger++
    $module = Get-AzAutomationModule -AutomationAccountName $automationaccountname -ResourceGroupName $resourcegroup -RuntimeVersion "7.2" -name $i.module 

    if($module.Version -ne $i.version -or $module.ProvisioningState -eq "Failed")
    {
        if($module.Version -ne $i.version)
        {
            $output = $i.module + " - wrong version, expected " + $i.version + ", but " + $module.Version + " was discovered. Upgrading - " + $trigger + "/" + $allmodules.count
            $silent = New-AzAutomationModule -AutomationAccountName $automationaccountname -ResourceGroupName $resourcegroup -name $i.module -ContentLinkUri $i.url -RuntimeVersion "7.2"
        }
        elseif($module.ProvisioningState -eq "Failed")
        {
            $output = $i.module + " module is in " + $module.ProvisioningState + " trying to reinstall - " + $trigger + "/" + $allmodules.count
            $silent = New-AzAutomationModule -AutomationAccountName $automationaccountname -ResourceGroupName $resourcegroup -name $i.module -ContentLinkUri $i.url -RuntimeVersion "7.2"
        }
    }
    else {
        $output = "Name: " + $i.module + " - current version: " + $i.version + " - expected version: " + $module.Version + " - " + $trigger + "/" + $allmodules.count
    }
    Write-Output $output           
}
