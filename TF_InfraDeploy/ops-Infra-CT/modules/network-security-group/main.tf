resource "azurerm_network_security_group" "nsg" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
  name                = "${var.name}"
}

locals {
  rules_locked_down_no = "${length(var.rules_locked_down)}"
  rules_groups_no      = "${length(var.rules_groups)}"
  rules_open_no        = "${length(var.rules_open)}"
}

resource "azurerm_network_security_rule" "rules_locked_down" {
  count                       = "${local.rules_locked_down_no != 0 ? length(var.rules_locked_down) : 0}"
  name                        = "${lookup(var.rules_locked_down[count.index], "name", "default_rule_name")}"
  priority                    = "${lookup(var.rules_locked_down[count.index], "priority")}"
  direction                   = "${lookup(var.rules_locked_down[count.index], "direction", "Any")}"
  access                      = "${lookup(var.rules_locked_down[count.index], "access", "Allow")}"
  protocol                    = "${lookup(var.rules_locked_down[count.index], "protocol", "*")}"
  source_port_range           = "${lookup(var.rules_locked_down[count.index], "source_port_range", "*")}"
  source_address_prefixes     = "${split(",", lookup(var.rules_locked_down[count.index], "source_address_prefixes", "*"))}"
  destination_port_range      = "${lookup(var.rules_locked_down[count.index], "destination_port_range", "*")}"
  destination_address_prefix  = "${lookup(var.rules_locked_down[count.index], "destination_address_prefix", "*")}"
  description                 = "${lookup(var.rules_locked_down[count.index], "description", "Security rule for ${lookup(var.rules_locked_down[count.index], "name", "default_rule_name")}")}"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}

resource "azurerm_network_security_rule" "rules_open" {
  count                       = "${local.rules_open_no != 0 ? length(var.rules_open) : 0}"
  name                        = "${lookup(var.rules_open[count.index], "name", "default_rule_name")}"
  priority                    = "${lookup(var.rules_open[count.index], "priority")}"
  direction                   = "${lookup(var.rules_open[count.index], "direction", "Any")}"
  access                      = "${lookup(var.rules_open[count.index], "access", "Allow")}"
  protocol                    = "${lookup(var.rules_open[count.index], "protocol", "*")}"
  source_port_range           = "${lookup(var.rules_open[count.index], "source_port_range", "*")}"
  source_address_prefix       = "${lookup(var.rules_open[count.index], "source_address_prefix", "*")}"
  destination_port_range      = "${lookup(var.rules_open[count.index], "destination_port_range", "*")}"
  destination_address_prefix  = "${lookup(var.rules_open[count.index], "destination_address_prefix", "*")}"
  description                 = "${lookup(var.rules_open[count.index], "description", "Security rule for ${lookup(var.rules_open[count.index], "name", "default_rule_name")}")}"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}

resource "azurerm_network_security_rule" "rules_groups" {
  count                                 = "${local.rules_groups_no != 0 ? length(var.rules_groups) : 0}"
  name                                  = "${lookup(var.rules_groups[count.index], "name", "default_rule_name")}"
  priority                              = "${lookup(var.rules_groups[count.index], "priority")}"
  direction                             = "${lookup(var.rules_groups[count.index], "direction", "Any")}"
  access                                = "${lookup(var.rules_groups[count.index], "access", "Allow")}"
  protocol                              = "${lookup(var.rules_groups[count.index], "protocol", "*")}"
  source_port_range                     = "${lookup(var.rules_groups[count.index], "source_port_range", "*")}"
  source_application_security_group_ids = ["${split(",", var.application_security_group_ids)}"]
  destination_port_range                = "${lookup(var.rules_groups[count.index], "destination_port_range", "*")}"
  destination_address_prefix            = "${lookup(var.rules_groups[count.index], "destination_address_prefix", "*")}"
  description                           = "${lookup(var.rules_groups[count.index], "description", "Security rule for ${lookup(var.rules_groups[count.index], "name", "default_rule_name")}")}"
  resource_group_name                   = "${var.resource_group_name}"
  network_security_group_name           = "${azurerm_network_security_group.nsg.name}"
}
