data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "SPC_dev_key_vault" {
   name               	     = "ri-d-inc-inp-spc-kv"
   resource_group_name       = var.resource_group.name
   location                  = var.resource_group.location
   tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                   =  "standard"
  network_acls {
    default_action = "Allow"
    bypass         = "None"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_key_vault_access_policy" "SPC_dev_key_vault_terraform_access_policy" {
  key_vault_id = azurerm_key_vault.SPC_dev_key_vault.id
   tenant_id    = data.azurerm_client_config.current.tenant_id
   object_id    = data.azurerm_client_config.current.object_id
    
  key_permissions = [
    "create",
    "get",
  ]

  secret_permissions = [
    "set",
    "get",
    "delete",
  ]
 }

/*
resource "azurerm_key_vault_access_policy" "SPC-dev-key_vault_service_principal_access_policy" {
  key_vault_id = azurerm_key_vault.SPC_dev_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
   object_id   = data.azurerm_client_config.current.object_id
  
  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}

resource "azurerm_key_vault_secret" "SPC_dev_key_vault_secret" {
  for_each = merge(var.key_vault_secrets, {
  
"MRX-ENV"=var.mr_kv_secrets.MRX-ENV
"MRX-APP-PUBLIC-URL"=var.mr_kv_secrets.MRX-APP-PUBLIC-URL
"MRX-API-PUBLIC-URL"=var.mr_kv_secrets.MRX-API-PUBLIC-URL
"MRX-API-BUILD-URL"=var.mr_kv_secrets.MRX-API-BUILD-URL
# "OKTA-LOGIN-URL"=var.mr_kv_secrets.OKTA-LOGIN-URL
"OKTA-API-URL"=var.mr_kv_secrets.OKTA-API-URL
"OKTA-API-TOKEN"=var.mr_kv_secrets.OKTA-API-TOKEN
"OKTA-API-ISSUER"=var.mr_kv_secrets.OKTA-API-ISSUER
"OKTA-API-BASE-URL"=var.mr_kv_secrets.OKTA-API-BASE-URL
# "OKTA-APP-CLIENT-TOKEN"=var.mr_kv_secrets.OKTA-APP-CLIENT-TOKEN
"DIS3-API-URL"=var.mr_kv_secrets.DIS3-API-URL
"DRUPAL-7-AUTH-PASS"=var.mr_kv_secrets.DRUPAL-7-AUTH-PASS
"DRUPAL-7-AUTH-USER"=var.mr_kv_secrets.DRUPAL-7-AUTH-USER
"DIS3-INTERNAL-KEY"=var.mr_kv_secrets.DIS3-INTERNAL-KEY
"DIS3-EXTERNAL-KEY"=var.mr_kv_secrets.DIS3-EXTERNAL-KEY
"SENDGRID-API-KEY"=var.mr_kv_secrets.SENDGRID-API-KEY
"RAPID7-TOKEN"=var.mr_kv_secrets.RAPID7-TOKEN
"RAPID7-REGION"=var.mr_kv_secrets.RAPID7-REGION
"DIS2-USERNAME"=var.mr_kv_secrets.DIS2-USERNAME
"DIS2-PASSWORD"=var.mr_kv_secrets.DIS2-PASSWORD
"SENDGRID-COMMON-TEMPLATE-ID"=var.mr_kv_secrets.SENDGRID-COMMON-TEMPLATE-ID
"DIS2-NOTIFICATIONS-SECRET"=var.mr_kv_secrets.DIS2-NOTIFICATIONS-SECRET
"GOOGLE-MAPS-JAVASCRIPT-API-KEY"=var.mr_kv_secrets.GOOGLE-MAPS-JAVASCRIPT-API-KEY
"BACKEND-APP-BASE-URL"=var.mr_kv_secrets.BACKEND-APP-BASE-URL
 "RAPID7-TOKEN-BACKEND"=var.mr_kv_secrets.RAPID7-TOKEN-BACKEND
 "RAPID7-TOKEN-FRONTEND"=var.mr_kv_secrets.RAPID7-TOKEN-FRONTEND
"REDIS-HOST"=var.mr_kv_secrets.REDIS-HOST     
"REDIS-PORT"=var.mr_kv_secrets.REDIS-PORT
"REDIS-PASSWORD"=var.mr_kv_secrets.REDIS-PASSWORD
# SESSION_LIFETIME 
"SESSION-SECRET"=var.mr_kv_secrets.SESSION-SECRET
SOLR-API-USER=var.mr_kv_secrets.SOLR-API-USER
SOLR-API-PASS=var.mr_kv_secrets.SOLR-API-PASS
SOLR-API-HOST=var.mr_kv_secrets.SOLR-API-HOST
SOLR-API-PORT=var.mr_kv_secrets.SOLR-API-PORT
SOLR-API-CORE=var.mr_kv_secrets.SOLR-API-CORE
NEW-RELIC-APP-NAME=var.mr_kv_secrets.NEW-RELIC-APP-NAME
NEW-RELIC-LICENSE-KEY=var.mr_kv_secrets.NEW-RELIC-LICENSE-KEY
NEWRELIC-ACCOUNTID=var.mr_kv_secrets.NEWRELIC-ACCOUNTID
NEWRELIC-TRUSTKEY=var.mr_kv_secrets.NEWRELIC-TRUSTKEY
NEWRELIC-AGENTID=var.mr_kv_secrets.NEWRELIC-AGENTID
NEWRELIC-LICENSEKEY=var.mr_kv_secrets.NEWRELIC-LICENSEKEY
NEWRELIC-APPLICATIONID=var.mr_kv_secrets.NEWRELIC-APPLICATIONID
  })
 
  name         = replace(each.key, "_", "-")
  value        = each.value
  key_vault_id = azurerm_key_vault.SPC_dev_key_vault.id

  tags = {
    environment = "dev"
 }
*/
