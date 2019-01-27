resource "azurerm_recovery_services_vault" "vault" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
  name                = "${var.name}"
  sku                 = "${var.sku}"
}

resource "azurerm_recovery_services_protection_policy_vm" "policy" {
  resource_group_name = "${var.resource_group_name}"
  tags                = "${var.tags}"
  recovery_vault_name = "${azurerm_recovery_services_vault.vault.name}"
  name                = "${var.name}-policy"

  backup = {
    frequency = "${var.frequency}"
    time      = "${var.time}"
  }

  retention_daily = {
    count = "${var.retention_daily}"
  }
}
