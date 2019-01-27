#################
# Get some informtion on the subnet we are going to be creating the NIC in
#################

data "azurerm_subnet" "subnet_info" {
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.vnet_name}"
  name                 = "${var.subnet_name}"
}

#################
# Create the NIC with a public IP address with a dynamic private address
#################

resource "azurerm_network_interface" "nic-public-dynamic" {
  count                     = "${contains(list("${var.type}"), "public") && contains(list("${var.private_ip_address_allocation}"), "dynamic") ? var.nb_nics : 0}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  tags                      = "${var.tags}"
  name                      = "${var.name}"
  network_security_group_id = "${var.nsg_id}"

  ip_configuration {
    name                           = "${var.name}-ip"
    subnet_id                      = "${data.azurerm_subnet.subnet_info.id}"
    private_ip_address_allocation  = "${var.private_ip_address_allocation}"
    public_ip_address_id           = "${var.public_ip_id}"
    application_security_group_ids = ["${var.asg_ids}"]
  }
}

#################
# Create the NIC with a public IP address with a static private address
#################

resource "azurerm_network_interface" "nic-public-static" {
  count                     = "${contains(list("${var.type}"), "public") && contains(list("${var.private_ip_address_allocation}"), "static") ? var.nb_nics : 0}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  tags                      = "${var.tags}"
  name                      = "${var.name}"
  network_security_group_id = "${var.nsg_id}"

  ip_configuration {
    name                           = "${var.name}-ip"
    subnet_id                      = "${data.azurerm_subnet.subnet_info.id}"
    private_ip_address_allocation  = "${var.private_ip_address_allocation}"
    private_ip_address             = "${var.private_ip_address}"
    public_ip_address_id           = "${var.public_ip_id}"
    application_security_group_ids = ["${var.asg_ids}"]
  }
}

#################
# Create the NIC with a dynamic private IP address
#################

resource "azurerm_network_interface" "nic-private-dynamic" {
  count                     = "${contains(list("${var.type}"), "private") && contains(list("${var.private_ip_address_allocation}"), "dynamic") ? var.nb_nics : 0}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  tags                      = "${var.tags}"
  name                      = "${var.name}"
  network_security_group_id = "${var.nsg_id}"

  ip_configuration {
    name                           = "${var.name}-ip"
    subnet_id                      = "${data.azurerm_subnet.subnet_info.id}"
    private_ip_address_allocation  = "${var.private_ip_address_allocation}"
    application_security_group_ids = ["${var.asg_ids}"]
  }
}

#################
# Create the NIC with a static private IP address
#################

resource "azurerm_network_interface" "nic-private-static" {
  count                     = "${contains(list("${var.type}"), "private") && contains(list("${var.private_ip_address_allocation}"), "static") ? var.nb_nics : 0}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"
  tags                      = "${var.tags}"
  name                      = "${var.name}"
  network_security_group_id = "${var.nsg_id}"

  ip_configuration {
    name                           = "${var.name}${var.type}"
    subnet_id                      = "${data.azurerm_subnet.subnet_info.id}"
    private_ip_address_allocation  = "${var.private_ip_address_allocation}"
    private_ip_address             = "${var.private_ip_address}"
    application_security_group_ids = ["${var.asg_ids}"]
  }
}
