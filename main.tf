terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

resource "azurerm_resource_group" "ABCO" {
  name     = "myrg87"
  location = "Central India"
}

resource "azurerm_storage_account" "billingcoldstorage" {
  name                     = "billingcoldstorage"
  resource_group_name      = azurerm_resource_group.ABCO.name
  location                 = azurerm_resource_group.ABCO.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.ABCO]
}

resource "azurerm_storage_container" "container" {
  name                  = "archived-records"
  storage_account_id    = azurerm_storage_account.billingcoldstorage.id
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.billingcoldstorage]
}

