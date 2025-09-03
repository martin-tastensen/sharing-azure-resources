resource "azurerm_log_analytics_workspace" "diagnostics_settings" {
  name                = var.diagnostics_settings
  location            = var.location
  resource_group_name = azurerm_resource_group.baseline_resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = var.diagnostics_settings_retention_period

  depends_on = [
    azurerm_logic_app_workflow.la_expiration_notification,
    azurerm_communication_service.mmt-notification-service
  ]
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics_settings" {
  name                       = "${var.diagnostics_settings}-logging"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.diagnostics_settings.id
  target_resource_id         = azurerm_communication_service.mmt-notification-service.id


  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "Traffic"
  }

  depends_on = [azurerm_log_analytics_workspace.diagnostics_settings]
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics_settings_logic_app" {
  name                       = "${var.diagnostics_settings}-logging"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.diagnostics_settings.id
  target_resource_id         = azurerm_logic_app_workflow.la_expiration_notification.id


  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_log_analytics_workspace.diagnostics_settings]
}

resource "azurerm_monitor_diagnostic_setting" "azurerm_automation_account_expiration-automation" {
  name                       = "${var.diagnostics_settings}-logging"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.diagnostics_settings.id
  target_resource_id         = azurerm_automation_account.expiration-automation.id


  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_log_analytics_workspace.diagnostics_settings]
}
