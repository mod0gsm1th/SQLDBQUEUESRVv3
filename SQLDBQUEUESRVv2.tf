############################  Sql server, two DB's, search service and service bus & queue  ##################################

resource "azurerm_resource_group" "ri-d-inc-inp-spc-rg" {
  name     = "ri-d-usc-spc-rg-SPC"
  location = "central us"
}

#######################  storage_account" #########################
resource "azurerm_storage_account" "ri-d-inc-inp-spc-sqlstoracc" {
  name                     = "ridincspcsqlacc"
  resource_group_name      = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  location                 = azurerm_resource_group.ri-d-inc-inp-spc-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#### SQL server ####
resource "azurerm_sql_server" "ri-d-inc-inp-spc-sql" {
  name                         = "ri-d-inc-inp-sqlserver"
  resource_group_name          = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  location                     = azurerm_resource_group.ri-d-inc-inp-spc-rg.location
  version                      = "12.0"
  administrator_login          = "misadmin"
  administrator_login_password = "wallYear1234"

  tags = {
    environment = "DEV"
  }
}

############################ SQL DB one  ###########################

resource "azurerm_sql_database" "ri-d-inc-inp-spc-db" {
  name                = "ri-d-inc-inp-spc-sdb"
  resource_group_name = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  location            = azurerm_resource_group.ri-d-inc-inp-spc-rg.location
  server_name         = azurerm_sql_server.ri-d-inc-inp-spc-sql.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.ri-d-inc-inp-spc-sqlstoracc.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.ri-d-inc-inp-spc-sqlstoracc.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "DEV"
  }
}

################################ DB two #############################

resource "azurerm_sql_database" "ri-d-inc-inp-spcq-db" {
  name                = "ri-d-inc-inp-spcq-sdb"
  resource_group_name = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  location            = azurerm_resource_group.ri-d-inc-inp-spc-rg.location
  server_name         = azurerm_sql_server.ri-d-inc-inp-spc-sql.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.ri-d-inc-inp-spc-sqlstoracc.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.ri-d-inc-inp-spc-sqlstoracc.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  tags = {
    environment = "DEV"
  }
}
##################################### service bus name space and and queue service #########################

resource "azurerm_servicebus_namespace" "ri-d-inc-inp-spc-servicebus" {
  name                = "ri-d-inc-inp-spc-servicebus-namespace"
  resource_group_name = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  location            = azurerm_resource_group.ri-d-inc-inp-spc-rg.location  
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}
resource "azurerm_servicebus_queue" "ri-d-inc-inp-spc-servicebus-queue" {
  name                = "ri-d-inc-inp-spc-servicebus-q"    
  resource_group_name = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  namespace_name      = azurerm_servicebus_namespace.ri-d-inc-inp-spc-servicebus.name

  enable_partitioning = true
}
######################### Search service   ########################################################################
resource "azurerm_search_service" "ri-d-inc-inp-spc-search" {
  name                = "ri-d-inc-inp-spc-search-service"
   resource_group_name = azurerm_resource_group.ri-d-inc-inp-spc-rg.name
  location            = azurerm_resource_group.ri-d-inc-inp-spc-rg.location
  sku                 = "standard"
}