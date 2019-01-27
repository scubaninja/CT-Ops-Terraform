output "vm_name" {
  description = "The name of the vm so we can use it in other modules"
  value       = "${flatten(concat(azurerm_virtual_machine.vm-linux.*.name,azurerm_virtual_machine.vm-windows.*.name))}"
}

output "vm_id" {
  description = "The id of the vm so we can use it in other modules"
  value       = "${flatten(concat(azurerm_virtual_machine.vm-linux.*.id,azurerm_virtual_machine.vm-windows.*.id))}"
}
