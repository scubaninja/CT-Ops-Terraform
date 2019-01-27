module "os" {
  source       = "./os"
  vm_os_simple = "${var.os}"
}

resource "azurerm_virtual_machine" "vm-linux" {
  count                 = "${contains(list("${module.os.calculated_value_os}"), "linux") ? var.nb_instances : 0}"
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  tags                  = "${var.tags}"
  name                  = "${var.name}"
  network_interface_ids = ["${var.nics}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "${module.os.calculated_value_os_publisher}"
    offer     = "${module.os.calculated_value_os_offer}"
    sku       = "${module.os.calculated_value_os_sku}"
    version   = "${var.os_version}"
  }

  storage_os_disk {
    name              = "${var.name}${var.os_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.os_disk_type}"
  }

  os_profile {
    computer_name  = "${var.name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm-windows" {
  count                 = "${contains(list("${module.os.calculated_value_os}"), "windows") ? var.nb_instances : 0}"
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  tags                  = "${var.tags}"
  name                  = "${var.name}"
  network_interface_ids = ["${var.nics}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "${module.os.calculated_value_os_publisher}"
    offer     = "${module.os.calculated_value_os_offer}"
    sku       = "${module.os.calculated_value_os_sku}"
    version   = "${var.os_version}"
  }

  storage_os_disk {
    name              = "${var.name}${var.os_disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.os_disk_type}"
    disk_size_gb      = "${var.os_disk_size}"
  }

  os_profile {
    computer_name  = "${var.name}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
