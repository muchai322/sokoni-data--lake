output "id" {
  description = "Storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "primary_dfs_endpoint" {
  description = "ADLS Gen2 DFS endpoint."
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}

output "container_names" {
  description = "Names of provisioned private containers."
  value       = sort(keys(azurerm_storage_container.this))
}
