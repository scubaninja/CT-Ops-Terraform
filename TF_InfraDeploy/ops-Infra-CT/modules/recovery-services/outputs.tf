output "recovery_vault_name" {
  description = "The id of the newly created recovery services vault"
  value       = "${azurerm_recovery_services_vault.vault.name}"
}

output "recovery_policy_id" {
  description = "The id of the newly created recovery services policy"
  value       = "${azurerm_recovery_services_protection_policy_vm.policy.id}"
}
