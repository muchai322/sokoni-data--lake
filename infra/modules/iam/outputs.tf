output "data_contributor_assignment_ids" {
  description = "Role assignment resource IDs for contributors."
  value       = [for assignment in azurerm_role_assignment.data_contributor : assignment.id]
}

output "data_reader_assignment_ids" {
  description = "Role assignment resource IDs for readers."
  value       = [for assignment in azurerm_role_assignment.data_reader : assignment.id]
}
