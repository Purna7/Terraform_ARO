terraform {
  backend "azurerm" {
    resource_group_name  = "<YOUR_RESOURCE_GROUP>"
    storage_account_name = "<YOUR_STORAGE_ACCOUNT>"
    container_name       = "<YOUR_CONTAINER>"
    key                  = "terraform.tfstate"
  }
}
