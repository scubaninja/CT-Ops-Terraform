resource "azurerm_lb_nat_rule" "loadbalancer_nat_rule_ftp" {
  count                          = "${var.no_of_ports}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${var.loadbalancer_id}"
  name                           = "${var.name}-${var.start_port + count.index}"
  protocol                       = "${var.protocol}"
  frontend_port                  = "${var.start_port + count.index}"
  backend_port                   = "${var.start_port + count.index}"
  frontend_ip_configuration_name = "${var.frontend_ip_configuration_name}"
}

resource "azurerm_network_interface_nat_rule_association" "loadbalancer_nat_rule_ftp" {
  count                 = "${var.no_of_ports}"
  network_interface_id  = "${var.network_interface_id}"
  ip_configuration_name = "${var.ip_configuration_name}"
  nat_rule_id           = "${azurerm_lb_nat_rule.loadbalancer_nat_rule_ftp.*.id[count.index]}"
}

resource "azurerm_network_security_rule" "open_nsg_for_nat_rule_ftp" {
  count                       = "${var.no_of_ports}"
  name                        = "${var.name}-${var.start_port + count.index}"
  priority                    = "${500 + count.index}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "${var.start_port + count.index}"
  destination_address_prefix  = "*"
  description                 = "Security rule for ${var.name}-${var.start_port + count.index}"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${var.network_security_group_name}"
}
