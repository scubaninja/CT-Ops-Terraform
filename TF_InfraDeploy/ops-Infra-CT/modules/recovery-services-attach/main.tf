resource "azurerm_recovery_services_protected_vm" "attach" {
  resource_group_name = "${var.resource_group_name}"
  tags                = "${var.tags}"
  recovery_vault_name = "${var.recovery_vault_name}"
  backup_policy_id    = "${var.backup_policy_id}"
  source_vm_id        = "${var.virtual_machine_id}"
}
