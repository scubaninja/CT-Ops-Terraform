######################################################################################################
# Local Setup
######################################################################################################

# What is the minimum version of Terraform we need?
terraform {
  required_version = ">= 0.11.0"
}

######################################################################################################
# Enviroment Setup
######################################################################################################

#################
# Create the resource group, using a resource here rather 
# than a module to allow the group to be created before
# we run anything else.
#################
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${merge(var.default_tags, map("type","resource"))}"
}

#################
# Create the VNET using a module
#################
module "application-vnet" {
  source              = "modules/vnet"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  vnet_name           = "${var.resource_group_name}-001"
  address_space       = "10.134.0.0/16"
}

module "application-subnets" {
  source              = "modules/subnet"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  vnet_name           = "${module.application-vnet.vnet_name}"

  subnets = [
    {
      name   = "Sub-CT-Prod"
      prefix = "10.134.20.0/24"
    },
    {
      name   = "Sub-CT-Data"
      prefix = "10.134.30.0/24"
    },
  ]
}

module "application-subnets-data" {
  source              = "modules/subnet"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  vnet_name           = "${module.application-vnet.vnet_name}"
  add_endpoint        = "true"

  subnets = [
    {
      name             = "CT_Prod_SNet_DMZ"
      prefix           = "10.134.10.0/24"
      service_endpoint = "Microsoft.Sql"
    },
    {
      name             = "CT_Prod_SNet_Mgt"
      prefix           = "10.134.11.0/24"
      service_endpoint = "Microsoft.Sql"
    },
  ]
}

######################################################################################################
# Application Secuity Groups
######################################################################################################

#################
# Add Mgt asg using the asg module
#################
module "asg-mgt" {
  source              = "modules/application-security-group"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  name                = "CT_Prod_ASG_Mgt"
}

######################################################################################################
# Network Security Groups
######################################################################################################

#################
# Add CT_Prod_NSG_Mgt using the nsg module
#################
module "nsg-mgt" {
  source              = "modules/network-security-group"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  name                = "CT_Prod_NSG_Mgt"
  rules_locked_down   = ["${var.jumphost_rules_locked_down}"]
}

#################
# Add CT_Prod_NSG_From_Mgt using the nsg module
#################
module "nsg-from-mgt" {
  source                         = "modules/network-security-group"
  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
  location                       = "${var.location}"
  tags                           = "${merge(var.default_tags, map("type","network"))}"
  name                           = "CT_Prod_NSG_From_Mgt"
  application_security_group_ids = "${module.asg-mgt.application_security_group_id}"
  rules_groups                   = ["${var.from_jumphost_rules_groups}"]
}

#################
# Add CT_Prod_NSG_From_Prod using the nsg module
#################
module "nsg-prod" {
  source              = "modules/network-security-group"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  name                = "CT_Prod_NSG_Prod"
  rules_open          = ["${var.prod_dev_rules_open}"]
}

#################
# Add CT_Prod_NSG_From_Dev using the nsg module
#################
module "nsg-dev" {
  source              = "modules/network-security-group"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"))}"
  name                = "CT_Prod_NSG_Dev"
  rules_open          = ["${var.prod_dev_rules_open}"]
}

######################################################################################################
# Database - Launch CTDevDB and CTProdDB
######################################################################################################

#################
# Launch the CTDevDB MySQL Database service
#################
module "CTDevDB" {
  source              = "modules/database-mysql"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","database"), map("group","CTDevDB"))}"
  name                = "CTdevdb"
  username            = "mysqladmin"
  password            = "DvVgY8XMGh7rzwUu7DGL"
  storage_mb          = "5120"

  sku = [
    {
      name     = "GP_Gen5_2"
      tier     = "GeneralPurpose"
      family   = "Gen5"
      capacity = "2"
    },
  ]

  num_subnets = "2"

  subnet_id = [
    "${element(module.application-subnets-data.vnet_subnets, 0)}",
    "${element(module.application-subnets-data.vnet_subnets, 1)}",
  ]
}

#################
# Launch the CTProdDB MySQL Database service
#################
module "CTProdDB" {
  source              = "modules/database-mysql"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","database"), map("group","CTDevDB"))}"
  name                = "CTproddb"
  username            = "mysqladmin"
  password            = "DvVgY8XMGh7rzwUu7DGL"
  storage_mb          = "5120"

  sku = [
    {
      name     = "MO_Gen5_4"
      tier     = "MemoryOptimized"
      family   = "Gen5"
      capacity = "4"
    },
  ]

  num_subnets = "2"

  subnet_id = [
    "${element(module.application-subnets-data.vnet_subnets, 0)}",
    "${element(module.application-subnets-data.vnet_subnets, 1)}",
  ]
}

######################################################################################################
# Recovery Services - CTRecovery
######################################################################################################

#################
# Create the recovery service and policy for CTRecovery
#################
module "CTRecovery" {
  source              = "modules/recovery-services"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","backup"))}"
  name                = "CTRecovery"
}

######################################################################################################
# Compute - CTPrdMgtBx
######################################################################################################

#################
# Create a public IP for CTPrdMgtBx
#################
module "CTPrdMgtBx-ip1" {
  source              = "modules/public-ip"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"), map("group","CTPrdMgtBx"))}"
  public_ip_name      = "CTPrdMgtBx-ip1"
}

#################
# Create a NIC for the CTPrdMgtBx
#################
module "CTPrdMgtBx-nic" {
  source              = "modules/network-interface"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"), map("group","CTPrdMgtBx"))}"
  name                = "NicCTPrdMgtBx"
  nsg_id              = "${module.nsg-mgt.network_security_group_id}"
  asg_ids             = ["${module.asg-mgt.application_security_group_id}"]
  vnet_name           = "${module.application-vnet.vnet_name}"
  subnet_name         = "${element(module.application-subnets-data.vnet_subnet_names, 0)}"
  type                = "public"
  public_ip_id        = "${module.CTPrdMgtBx-ip1.public_ip_id}"
}

#################
# Launch CTPrdMgtBx
#################
module "CTPrdMgtBx-compute" {
  source              = "modules/compute"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","compute"), map("group","CTPrdMgtBx"))}"
  name                = "CTPrdMgtBx"
  username            = "Node4"
  password            = "IUGtjZIO7KT6PrJ6eho"
  nics                = ["${module.CTPrdMgtBx-nic.nic_id}"]
  vm_size             = "Standard_B2s"
  os                  = "WindowsServer2016"
  os_disk_name        = "Disk1"
  os_disk_type        = "Standard_LRS"
  os_disk_size        = "127"
}

#################
# Attach VM to CTRecovery
#################
module "CTPrdMgtBx-backup" {
  source              = "modules/recovery-services-attach"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  tags                = "${merge(var.default_tags, map("type","backup"), map("group","CTPrdMgtBx"))}"
  recovery_vault_name = "${module.CTRecovery.recovery_vault_name}"
  backup_policy_id    = "${module.CTRecovery.recovery_policy_id}"
  virtual_machine_id  = "${element(module.CTPrdMgtBx-compute.vm_id, 0)}"
}

######################################################################################################
# Compute - CTProdAdm
######################################################################################################

#################
# Create a public IP for CTPrdAdm
#################
module "CTPrdAdm-ip1" {
  source              = "modules/public-ip"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"), map("group","CTPrdAdm"))}"
  public_ip_name      = "CTPrdAdm-ip1"
}

#################
# Create a NIC for the CTPrdAdm
#################
module "CTPrdAdm-nic" {
  source              = "modules/network-interface"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"), map("group","CTPrdAdm"))}"
  name                = "NicCTProdAdm"
  nsg_id              = "${module.nsg-mgt.network_security_group_id}"
  asg_ids             = ["${module.asg-mgt.application_security_group_id}"]
  vnet_name           = "${module.application-vnet.vnet_name}"
  subnet_name         = "${element(module.application-subnets-data.vnet_subnet_names, 0)}"
  type                = "public"
  public_ip_id        = "${module.CTPrdAdm-ip1.public_ip_id}"
}

#################
# Launch CTPrdAdm
#################
module "CTPrdAdm-compute" {
  source              = "modules/compute"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","compute"), map("group","CTPrdAdm"))}"
  name                = "CTPrdAdm"
  username            = "node4"
  password            = "IUGtjZIO7KT6PrJ6eho"
  nics                = ["${module.CTPrdAdm-nic.nic_id}"]
  os                  = "CentOS"
  os_disk_name        = "Disk1"
  os_disk_type        = "Standard_LRS"
  os_disk_size        = "127"
}

#################
# Attach VM to CTRecovery
#################
module "CTPrdAdm-backup" {
  source              = "modules/recovery-services-attach"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  tags                = "${merge(var.default_tags, map("type","backup"), map("group","CTPrdAdm"))}"
  recovery_vault_name = "${module.CTRecovery.recovery_vault_name}"
  backup_policy_id    = "${module.CTRecovery.recovery_policy_id}"
  virtual_machine_id  = "${element(module.CTPrdAdm-compute.vm_id, 0)}"
}

######################################################################################################
# Compute - CTDevWeb
######################################################################################################

#################
# Create a NIC for the CTDevWeb
#################
module "CTDevWeb-nic" {
  source              = "modules/network-interface"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"), map("group","CTDevWeb"))}"
  name                = "CTDevWeb"
  nsg_id              = "${module.nsg-dev.network_security_group_id}"
  vnet_name           = "${module.application-vnet.vnet_name}"
  subnet_name         = "${element(module.application-subnets-data.vnet_subnet_names, 1)}"
  type                = "private"
}

#################
# Launch CTDevWeb
#################
module "CTDevWeb-compute" {
  source              = "modules/compute"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","compute"), map("group","CTDevWeb"))}"
  name                = "CTDevWeb"
  username            = "node4"
  password            = "IUGtjZIO7KT6PrJ6eho"
  nics                = ["${module.CTDevWeb-nic.nic_id}"]
  os                  = "WindowsServer2012"
  vm_size             = "Standard_B2s"
  os_disk_name        = "Disk1"
  os_disk_type        = "Standard_LRS"
  os_disk_size        = "127"
}

#################
# Attach VM to CTRecovery
#################
module "CTDevWeb-backup" {
  source              = "modules/recovery-services-attach"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  tags                = "${merge(var.default_tags, map("type","backup"), map("group","CTDevWeb"))}"
  recovery_vault_name = "${module.CTRecovery.recovery_vault_name}"
  backup_policy_id    = "${module.CTRecovery.recovery_policy_id}"
  virtual_machine_id  = "${element(module.CTDevWeb-compute.vm_id, 0)}"
}

######################################################################################################
# Load Balancer - LBCTDevWeb
######################################################################################################

#################
# Create a public IP for LBCTDevWeb
#################
module "LBCTDevWeb-ip1" {
  source               = "modules/public-ip"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  location             = "${var.location}"
  tags                 = "${merge(var.default_tags, map("type","loadbalancer"), map("group","CTDevWeb"))}"
  public_ip_name       = "LBCTDevWeb-ip1"
  public_ip_allocation = "Static"
}

#################
# Launch the LBCTDevWeb Load Balancer
#################
module "LBCTDevWeb" {
  source              = "modules/loadbalancer"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","loadbalancer"), map("group","CTDevWeb"))}"
  name                = "LBCTDevWeb"
  type                = "public"
  public_ip_id        = "${module.LBCTDevWeb-ip1.public_ip_id}"
  subnet_id           = "${element(module.application-subnets-data.vnet_subnet_names, 1)}"
  remote_ports        = ["${var.lb_nat_rules}"]
}

#################
# Connect the CTDevWeb NIC to the LBCTDevWeb load balancer
# You need to manually set "no_of_nat_rules" to be the number of rules
# you added above due to a know issue with terraform using computed counts
#################
module "CTDevWeb-backend-association" {
  source                  = "modules/loadbalancer-backend-association"
  no_of_nat_rules         = "5"
  network_interface_id    = "${module.CTDevWeb-nic.nic_id[0]}"
  ip_configuration_name   = "CTDevWeb-ip"
  backend_address_pool_id = "${module.LBCTDevWeb.lb_backend_address_pool_id}"
  nat_rules               = "${module.LBCTDevWeb.lb_nat_rule_ids}"
}

#################
# Add the passive FTP NAT Ports the LBCTProdWeb
# Load Balancer using a counter so we don't have to define
# the rule x 25, this also attached the rules to the NIC
#################
module "LBCTDevWeb-FTP" {
  source                         = "modules/loadbalancer-nat-ftp"
  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
  name                           = "ftp"
  frontend_ip_configuration_name = "LBCTDevWebPublicIPAddress"
  loadbalancer_id                = "${module.LBCTDevWeb.lb_id}"
  no_of_ports                    = "25"
  start_port                     = "1024"
  network_interface_id           = "${module.CTDevWeb-nic.nic_id[0]}"
  ip_configuration_name          = "CTDevWeb-ip"
  backend_address_pool_id        = "${module.LBCTDevWeb.lb_backend_address_pool_id}"
  network_security_group_name    = "${module.nsg-dev.network_security_group_name}"
}

######################################################################################################
# Compute - CTProdWeb
######################################################################################################

#################
# Create a NIC for the CTProdWeb
#################
module "CTProdWeb-nic" {
  source              = "modules/network-interface"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","network"), map("group","CTProdWeb"))}"
  name                = "CTProdWeb"
  nsg_id              = "${module.nsg-prod.network_security_group_id}"
  vnet_name           = "${module.application-vnet.vnet_name}"
  subnet_name         = "${element(module.application-subnets-data.vnet_subnet_names, 1)}"
  type                = "private"
}

#################
# Launch CTProdWeb
#################
module "CTProdWeb-compute" {
  source              = "modules/compute"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","compute"), map("group","CTProdWeb"))}"
  name                = "CTProdWeb"
  username            = "node4"
  password            = "IUGtjZIO7KT6PrJ6eho"
  nics                = ["${module.CTProdWeb-nic.nic_id}"]
  os                  = "WindowsServer2012"
  vm_size             = "Standard_B2s"
  os_disk_name        = "Disk1"
  os_disk_type        = "Standard_LRS"
  os_disk_size        = "127"
}

#################
# Attach a data disc to CTProdWeb
#################
module "CTProdWeb-datadisk" {
  source              = "modules/compute-disk"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","compute"), map("group","CTProdWeb"))}"
  disk_name           = "CTProdWebDataDisk"
  virtual_machine_id  = "${element(module.CTProdWeb-compute.vm_id, 0)}"
  disk_type           = "Standard_LRS"
  disk_size           = "10"
  lun                 = "10"
}

#################
# Attach VM to CTRecovery
#################
module "CTProdWeb-backup" {
  source              = "modules/recovery-services-attach"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  tags                = "${merge(var.default_tags, map("type","backup"), map("group","CTProdWeb"))}"
  recovery_vault_name = "${module.CTRecovery.recovery_vault_name}"
  backup_policy_id    = "${module.CTRecovery.recovery_policy_id}"
  virtual_machine_id  = "${element(module.CTProdWeb-compute.vm_id, 0)}"
}

######################################################################################################
# Load Balancer - LBCTProdWeb
######################################################################################################

#################
# Create a public IP for LBCTProdWeb
#################
module "LBCTProdWeb-ip1" {
  source               = "modules/public-ip"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  location             = "${var.location}"
  tags                 = "${merge(var.default_tags, map("type","loadbalancer"), map("group","CTProdWeb"))}"
  public_ip_name       = "LBCTProdWeb-ip1"
  public_ip_allocation = "Static"
}

#################
# Launch the LBCTProdWeb Load Balancer
#################
module "LBCTProdWeb" {
  source              = "modules/loadbalancer"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  tags                = "${merge(var.default_tags, map("type","loadbalancer"), map("group","CTProdWeb"))}"
  name                = "LBCTProdWeb"
  type                = "public"
  public_ip_id        = "${module.LBCTProdWeb-ip1.public_ip_id}"
  subnet_id           = "${element(module.application-subnets-data.vnet_subnet_names, 1)}"
  remote_ports        = ["${var.lb_nat_rules}"]
}

#################
# Connect the CTProdWeb NIC to the LBCTProdWeb load balancer
# You need to manually set "no_of_nat_rules" to be the number of rules
# you added above due to a know issue with terraform using computed counts
#################
module "CTProdWeb-backend-association" {
  source                  = "modules/loadbalancer-backend-association"
  no_of_nat_rules         = "5"
  network_interface_id    = "${module.CTProdWeb-nic.nic_id[0]}"
  ip_configuration_name   = "CTProdWeb-ip"
  backend_address_pool_id = "${module.LBCTProdWeb.lb_backend_address_pool_id}"
  nat_rules               = "${module.LBCTProdWeb.lb_nat_rule_ids}"
}

#################
# Add the passive FTP NAT Ports the LBCTProdWeb
# Load Balancer using a counter so we don't have to define
# the rule x 25, this also attached the rules to the NIC
#################
module "LBCTProdWeb-FTP" {
  source                         = "modules/loadbalancer-nat-ftp"
  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
  name                           = "ftp"
  frontend_ip_configuration_name = "LBCTProdWebPublicIPAddress"
  loadbalancer_id                = "${module.LBCTProdWeb.lb_id}"
  no_of_ports                    = "25"
  start_port                     = "1024"
  network_interface_id           = "${module.CTProdWeb-nic.nic_id[0]}"
  ip_configuration_name          = "CTProdWeb-ip"
  backend_address_pool_id        = "${module.LBCTProdWeb.lb_backend_address_pool_id}"
  network_security_group_name    = "${module.nsg-prod.network_security_group_name}"
}
