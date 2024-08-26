resource "azurerm_resource_group" "baseline_resource_group" {
  name     = var.baseline_resource_group_name
  location = local.Primary_location
  tags     = local.tags
}