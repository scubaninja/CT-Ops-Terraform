resource "azurerm_managed_disk" "compute" {
  resource_group_name  = "${var.resource_group_name}"
  location             = "${var.location}"
  tags                 = "${var.tags}"
  name                 = "${var.disk_name}"
  storage_account_type = "${var.disk_type}"
  create_option        = "${var.disk_create_option}"
  disk_size_gb         = "${var.disk_size}"
}

resource "azurerm_virtual_machine_data_disk_attachment" "compute" {
  managed_disk_id    = "${azurerm_managed_disk.compute.id}"
  virtual_machine_id = "${var.virtual_machine_id}"
  lun                = "${var.lun}"
  caching            = "${var.caching}"
}
