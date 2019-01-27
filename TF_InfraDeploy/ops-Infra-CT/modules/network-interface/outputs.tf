output "nic_id" {
  description = "The id of the newly created NIC"
  value       = "${concat(azurerm_network_interface.nic-public-dynamic.*.id,azurerm_network_interface.nic-public-static.*.id,azurerm_network_interface.nic-private-dynamic.*.id,azurerm_network_interface.nic-private-static.*.id)}"
}

output "nic_name" {
  description = "The Name of the newly created NIC"
  value       = "${concat(azurerm_network_interface.nic-public-dynamic.*.name,azurerm_network_interface.nic-public-static.*.name,azurerm_network_interface.nic-private-dynamic.*.name,azurerm_network_interface.nic-private-static.*.name)}"
}

output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = "${join("",concat(azurerm_network_interface.nic-public-dynamic.*.private_ip_address,azurerm_network_interface.nic-public-static.*.private_ip_address,azurerm_network_interface.nic-private-dynamic.*.private_ip_address,azurerm_network_interface.nic-private-static.*.private_ip_address))}"
}
