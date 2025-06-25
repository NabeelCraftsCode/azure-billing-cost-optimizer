terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "eed4b87f-0012-48f8-8ba6-d6183ef0f528"
  client_id       = "518ace1f-b788-42ca-9827-4c3570b912d7"
  client_secret   = "BQU8Q~SGY2Tuuk.OA6QyksH0~CMXF6T60gdA8aWo"
  tenant_id       = "cc5b55bb-0e45-4815-a2d1-bb38289c4075"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
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

