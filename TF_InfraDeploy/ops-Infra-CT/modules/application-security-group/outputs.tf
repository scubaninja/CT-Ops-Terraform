output "application_security_group_id" {
  value = "${azurerm_application_security_group.asg.id}"
}

output "application_security_group_name" {
  value = "${azurerm_application_security_group.asg.name}"
}
