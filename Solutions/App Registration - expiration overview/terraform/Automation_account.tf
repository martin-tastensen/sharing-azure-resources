resource "azurerm_automation_account" "expiration-automation" {
  name                = var.automation_account_solution_name
  location            = local.Primary_location
  resource_group_name = azurerm_resource_group.baseline_resource_group.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

/* resource "azurerm_automation_powershell72_module" "module-az" {
  name                  = "az"
  automation_account_id = azurerm_automation_account.expiration-automation.id

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/az.12.2.0.nupkg"
  }
  depends_on = [azurerm_automation_account.expiration-automation]
}
 */
resource "azurerm_automation_powershell72_module" "microsoft-graph" {
  name                  = "Microsoft.Graph"
  automation_account_id = azurerm_automation_account.expiration-automation.id

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.2.22.0.nupkg"
  }
  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_powershell72_module" "Microsoft-Graph-Applications" {
  name                  = "Microsoft.Graph.Applications"
  automation_account_id = azurerm_automation_account.expiration-automation.id

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.applications.2.22.0.nupkg"
  }
  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_powershell72_module" "Microsoft-Graph-Authentication" {
  name                  = "Microsoft.Graph.Authentication"
  automation_account_id = azurerm_automation_account.expiration-automation.id

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.authentication.2.22.0.nupkg"
  }
  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_powershell72_module" "Microsoft-Graph-Identity-DirectoryManagement" {
  name                  = "Microsoft.Graph.Identity.DirectoryManagement"
  automation_account_id = azurerm_automation_account.expiration-automation.id

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/microsoft.graph.identity.directorymanagement.1.4.0.nupkg"
  }
  depends_on = [azurerm_automation_account.expiration-automation]
}


data "local_file" "runbook-script" {
  filename = "${path.module}/../App Registration - expiration overview.ps1"
}

resource "azurerm_automation_runbook" "verify-secret-expiration" {
  name                    = "verify-secret-expiration"
  location                = local.Primary_location
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  log_verbose             = "false"
  log_progress            = "false"
  description             = "Get a list of all app registrations, with expired or soon to expire secrets and certificates"
  runbook_type            = "PowerShell72"

  content = data.local_file.runbook-script.content
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

