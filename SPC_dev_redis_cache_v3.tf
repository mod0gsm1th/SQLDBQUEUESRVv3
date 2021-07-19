resource "azurerm_redis_cache" "spc-dev-redis" {
    name                       = "ri-d-inc-inp-spc-redis"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location  
  capacity                     = 1
  family                       = "p"
  sku_name                     = "Premium"
  enable_non_ssl_port          = false
  minimum_tls_version          = "1.2"
  shard_count                  = 2
  redis_configuration {
      enable_authentication = true

  }
  
}