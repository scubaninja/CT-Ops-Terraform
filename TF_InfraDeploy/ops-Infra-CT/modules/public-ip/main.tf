resource "azurerm_public_ip" "public_ip" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
  name                = "${var.public_ip_name}"
  allocation_method   = "${var.public_ip_allocation}"
}
