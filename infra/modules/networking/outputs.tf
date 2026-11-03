output "virtual_network_id" {
  description = "Virtual network resource ID."
  value       = azurerm_virtual_network.this.id
}

output "subnet_id" {
  description = "Data subnet resource ID."
  value       = azurerm_subnet.data.id
}
