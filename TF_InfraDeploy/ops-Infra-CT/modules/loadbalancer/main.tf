resource "azurerm_lb" "loadbalancer" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
  name                = "${var.name}"

  frontend_ip_configuration {
    name                          = "${var.name}PublicIPAddress"
    public_ip_address_id          = "${var.type == "public" ? var.public_ip_id : ""}"
    subnet_id                     = "${var.frontend_subnet_id}"
    private_ip_address            = "${var.frontend_private_ip_address}"
    private_ip_address_allocation = "${var.frontend_private_ip_address_allocation}"
  }
}

resource "azurerm_lb_backend_address_pool" "loadbalancer_backend_address_pool" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.loadbalancer.id}"
  name                = "${var.name}PublicIPAddress"
}

resource "azurerm_lb_nat_rule" "loadbalancer_nat_rule" {
  count                          = "${length(var.remote_ports)}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.loadbalancer.id}"
  name                           = "${lookup(var.remote_ports[count.index], "name", "default_rule_name")}"
  protocol                       = "${lookup(var.remote_ports[count.index], "protocol", "Tcp")}"
  frontend_port                  = "${lookup(var.remote_ports[count.index], "frontend_port", "3389")}"
  backend_port                   = "${lookup(var.remote_ports[count.index], "backend_port", "3389")}"
  frontend_ip_configuration_name = "${var.name}PublicIPAddress"
}
