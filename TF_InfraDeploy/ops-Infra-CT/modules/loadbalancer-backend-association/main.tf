resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  network_interface_id    = "${var.network_interface_id}"
  ip_configuration_name   = "${var.ip_configuration_name}"
  backend_address_pool_id = "${var.backend_address_pool_id}"
}

resource "azurerm_network_interface_nat_rule_association" "backend" {
  count                 = "${var.no_of_nat_rules}"
  network_interface_id  = "${var.network_interface_id}"
  ip_configuration_name = "${var.ip_configuration_name}"
  nat_rule_id           = "${var.nat_rules[count.index]}"
}
