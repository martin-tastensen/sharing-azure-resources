resource "azurerm_automation_account" "expiration-automation" {
  name                = var.automation_account_solution_name
  location            = var.location
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

data "local_file" "runbook-script" {
  filename = "${path.module}/../App Registration - expiration overview.ps1"
}

data "local_file" "update-modules" {
  filename = "${path.module}/../Support-scripts/Update-default-modules.ps1"
}

resource "azurerm_automation_runbook" "verify-secret-expiration" {
  name                    = "verify-secret-expiration"
  location                = var.location
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  log_verbose             = "false"
  log_progress            = "true"
  description             = "Get a list of all app registrations, with expired or soon to expire secrets and certificates"
  runbook_type            = "PowerShell72"

  content = data.local_file.runbook-script.content
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

resource "azurerm_automation_runbook" "update-az-modules" {
  name                    = "update-az-modules"
  location                = var.location
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  log_verbose             = "false"
  log_progress            = "false"
  description             = "Update azure modules"
  runbook_type            = "PowerShell72"

  content = data.local_file.update-modules.content
  depends_on = [
    azurerm_resource_group.baseline_resource_group
  ]
}

resource "azurerm_automation_powershell72_module" "Microsoft-modules" {
  for_each = { for id, value in local.microsoft_graph_modules.modules : id => value }

  name                  = each.value.name
  automation_account_id = azurerm_automation_account.expiration-automation.id

  module_link {
    uri = "${each.value.uri}.${each.value.version}.${each.value.type}"
  }

  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_schedule" "Onetime" {
  name                    = "onetime-schedule"
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  frequency               = "OneTime"
  description             = "Onetime job, that will update and install all required modules for the script to run"
  
  depends_on = [azurerm_automation_account.expiration-automation]
}

resource "azurerm_automation_job_schedule" "example" {
  resource_group_name     = azurerm_resource_group.baseline_resource_group.name
  automation_account_name = azurerm_automation_account.expiration-automation.name
  schedule_name           = azurerm_automation_schedule.Onetime.name
  runbook_name            = azurerm_automation_runbook.update-az-modules.name

depends_on = [ azurerm_automation_schedule.Onetime ]
}