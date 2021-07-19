/*
#The first thing we�ll need to do is specify the Resource Group we�d like to create:
#33
resource "azurerm_resource_group" "spc-dev-rg" {
  name     = "ri-d-inc-inp-spc-rg"
  location = "Central India"
}
*/
#Then, we need to specify the Storage Account:
resource "azurerm_storage_account" "spc-dev-stg" {
  name                     = "ridevinpspc01stg"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
  #access_tier = "Hot"
  #account_kind = "StorageV2"
}
#It�s time to specify the Service Plan:
resource "azurerm_app_service_plan" "spc-dev-fa-asp" {
  name                      = "ri-d-inc-inp-spc-fa-asp"
  resource_group_name       = var.resource_group.name
  location                  = var.resource_group.location
  kind                      = "linux"
  reserved = "true"
  sku {
    tier = "PremiumV2"
    size = var.function_node_size

    #tier = "Standard"
    #size = "S1"
  }
}
resource "azurerm_monitor_autoscale_setting" "spc-dev-autoscale" {
  count = var.enable_autoscaling ? 1 : 0

  name                         = "ri-d-inc-inp-spc-autoscale-584" 
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  target_resource_id  = azurerm_app_service_plan.spc-dev-fa-asp.id

  profile {
    name = "Auto created scale condition"

    capacity {
      default = 1
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.spc-dev-fa-asp.id 
        statistic          = "Average"
        time_window        = "PT5M"
        time_grain         = "PT1M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 60
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.spc-dev-fa-asp.id
        statistic          = "Average"
        time_window        = "PT10M"
        time_grain         = "PT1M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 40
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }


  }
}
resource "azurerm_application_insights" "spc-dev-fa-ai" {
  name                         = "ri-d-inc-inp-spc-fa-ai"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  application_type    = "web"
}

#And finally we need to create the Function App and tell it that it needs to take the code from the uploaded zip file:
resource "azurerm_function_app" "spc-dev-fa" {
  name                         = "ri-d-inc-inp-spc-fa"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  app_service_plan_id          = azurerm_app_service_plan.spc-dev-fa-asp.id
  storage_connection_string    = azurerm_storage_account.spc-dev-stg.primary_connection_string
  version                      = "~2"
  enable_builtin_logging       = false
  os_type                      = "linux"
}
 


