resource "azurerm_resource_group" "ri-d-inc-inp-spc-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

#######################  storage_account" #########################
resource "azurerm_storage_account" "ri-u-inc-inp-spc-sqlstoracc" {
  name                     = "riuincspcsqlacc"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

######################### SQL server ################################
resource "azurerm_sql_server" "ri-u-inc-inp-spc-sql" {
  name                         = "ri-u-inc-inp-sqlserver"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  version                      = "12.0"
  administrator_login          = "misadmin"
  administrator_login_password = "wallYear1234"

  tags = {
    environment = "UAT"
  }
}

############################ SQL DB one  ###########################

resource "azurerm_sql_database" "ri-u-inc-inp-spc-db" {
  name                = "ri-u-inc-inp-spc-sdb"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  server_name         = azurerm_sql_server.ri-u-inc-inp-spc-sql.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.ri-u-inc-inp-spc-sqlstoracc.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.ri-u-inc-inp-spc-sqlstoracc.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "UAT"
  }
}

################################ SQL DB two #############################

resource "azurerm_sql_database" "ri-u-inc-inp-spcq-db" {
  name                = "ri-u-inc-inp-spcq-sdb"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  server_name         = azurerm_sql_server.ri-u-inc-inp-spc-sql.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.ri-u-inc-inp-spc-sqlstoracc.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.ri-u-inc-inp-spc-sqlstoracc.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "UAT"
  }
}
##################################### service bus name space and queue service #########################

resource "azurerm_servicebus_namespace" "ri-u-inc-inp-spc-servicebus" {
  name                = "ri-u-inc-inp-spc-servicebus-namespace"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location  
  sku                 = "Standard"

  tags = {
    environment = "UAT"
    source = "terraform"
  }
}
resource "azurerm_servicebus_queue" "ri-u-inc-inp-spc-servicebus-queue" {
  name                = "ri-u-inc-inp-spc-servicebus-q"    
  resource_group_name = var.resource_group.name
  namespace_name      = azurerm_servicebus_namespace.ri-u-inc-inp-spc-servicebus.name

  enable_partitioning = true
}
######################### Search service   ########################################################################
resource "azurerm_search_service" "ri-u-inc-inp-spc-search" {
  name                = "ri-u-inc-inp-spc-search-service"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  sku                 = "standard"
}