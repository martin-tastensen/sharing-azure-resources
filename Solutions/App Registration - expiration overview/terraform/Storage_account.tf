resource "random_string" "storage_account_name" {
  length  = 16
  special = false
  upper   = false
  numeric = false
}

# Create storage account for saving the SP's with expired keys, and no owners
resource "azurerm_storage_account" "storage_account_temp_storage" {
  name                     = random_string.storage_account_name.result
  resource_group_name      = azurerm_resource_group.baseline_resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = local.tags

  depends_on = [
    azurerm_resource_group.baseline_resource_group,
    random_string.storage_account_name
  ]
}

resource "azurerm_storage_container" "blob_storage_temp" {
  name                  = "temp-storage"
  storage_account_name  = azurerm_storage_account.storage_account_temp_storage.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.storage_account_temp_storage]
}
