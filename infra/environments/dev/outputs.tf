output "resource_group_name" {
  description = "Environment resource group name."
  value       = module.resource_group.name
}

output "storage_account_name" {
  description = "ADLS Gen2 account name."
  value       = module.storage.name
}

output "storage_dfs_endpoint" {
  description = "ADLS Gen2 DFS endpoint."
  value       = module.storage.primary_dfs_endpoint
}

output "storage_container_names" {
  description = "Provisioned private container names."
  value       = module.storage.container_names
}

output "log_analytics_workspace_name" {
  description = "Monitoring workspace name."
  value       = module.monitoring.workspace_name
}
