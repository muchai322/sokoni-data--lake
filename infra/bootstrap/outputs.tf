output "state_resource_group_name" {
  description = "Resource group containing the remote state resources."
  value       = azurerm_resource_group.state.name
}

output "state_storage_account_name" {
  description = "Storage account containing the remote state container."
  value       = azurerm_storage_account.state.name
}

output "state_container_name" {
  description = "Private Blob container for Terraform remote state."
  value       = azurerm_storage_container.state.name
}

output "key_vault_name" {
  description = "Bootstrap Key Vault name."
  value       = azurerm_key_vault.bootstrap.name
}

output "key_vault_id" {
  description = "Bootstrap Key Vault resource ID."
  value       = azurerm_key_vault.bootstrap.id
}
