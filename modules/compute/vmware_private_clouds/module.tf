resource "azurecaf_name" "vwpc" {
  name          = var.settings.name
  resource_type = "azurerm_dedicated_host"#"azurerm_vmware_private_cloud"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

# Last review :  AzureRM version 2.63.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dedicated_host

data "azurerm_key_vault_secret" "nsxt_password" {
  for_each = try(var.settings.nsxt_password.secret_key,null) == null ||  try(var.keyvaults[var.settings.nsxt_password.keyvault_key].id,null) == null ? toset([]) : toset(["enabled"])
  name         =  var.settings.nsxt_password.secret_key
  key_vault_id =  var.keyvaults[var.settings.nsxt_password.keyvault_key].id
}
data "azurerm_key_vault_secret" "vcenter_password" {
  for_each = try(var.settings.vcenter_password.secret_key,null) == null ||  try(var.keyvaults[var.settings.vcenter_password.keyvault_key].id,null) == null ? toset([]) : toset(["enabled"])
  name         =  var.settings.vcenter_password.secret_key
  key_vault_id =  var.keyvaults[var.settings.vcenter_password.keyvault_key].id
}

resource "azurerm_vmware_private_cloud" "vwpc" {
  name                            = azurecaf_name.vwpc.result
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku_name                        = var.settings.sku_name
  management_cluster{
    size                          = var.settings.management_cluster.size
  }             
  network_subnet_cidr             = var.settings.network_subnet_cidr
  internet_connection_enabled     = try(var.settings.internet_connection_enabled, false)

  nsxt_password                   = try(var.settings.nsxt_password.password,data.azurerm_key_vault_secret.nsxt_password["enabled"].value,null)
  vcenter_password                = try(var.settings.vcenter_password.password,data.azurerm_key_vault_secret.vcenter_password["enabled"].value,null)
  
  tags                            = local.tags
}