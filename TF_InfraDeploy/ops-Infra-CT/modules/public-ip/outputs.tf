output "public_ip_id" {
  description = "The id of the newly created public ip"
  value       = "${azurerm_public_ip.public_ip.id}"
}

output "public_ip_name" {
  description = "The Name of the newly created public ip"
  value       = "${azurerm_public_ip.public_ip.name}"
}
