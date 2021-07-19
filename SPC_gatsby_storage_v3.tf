resource "azurerm_storage_account" "spc-dev-stg-gtby" {
  name                     = "ridevinpspc04stg"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  account_kind             = "StorageV2"
  enable_https_traffic_only = true
  static_website {
    index_document         = "index.html"
    error_404_document     = "index.html"
  }

   /*
    #network_rules {
    #default_action             = "Deny"
    #ip_rules                   = ["52.185.68.84"]
    #virtual_network_subnet_ids = ["/subscriptions/e9c5304c-ec60-40c7-84ef-4a4dadd75289/resourceGroups/ri-prd-usc-cor-rg-appgw/providers/Microsoft.Network/virtualNetworks/ri-prd-usc-cor-02-vnet-appgw/subnets/ri-prd-usc-cor-01-sub-appgw"]
  # }
*/


}

#### test code for enabling static website feature on storage account
module "staticweb" {
  source               = "StefanSchoof/static-website/azurerm"
  storage_account_name = azurerm_storage_account.spc-dev-stg-gtby.name
}

data "azurerm_storage_account" "test" {
  name                = azurerm_storage_account.spc-dev-stg-gtby.name
  resource_group_name = azurerm_resource_group.spc-dev-rg.name

  depends_on = [module.staticweb]
}

output "static-web-url" {
  value = data.azurerm_storage_account.test.primary_web_endpoint
}