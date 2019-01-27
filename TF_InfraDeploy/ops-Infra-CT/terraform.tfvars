######################################################################################################
# Supply values for your environment-specific variables here
######################################################################################################

#################
# Resource group and location information
#################
resource_group_name  = "UKW_CT_Prod"
location             = "UKSouth"

#################
# Default tags
#################

default_tags = {
  project     = "UKW_CT_Prod"
  environment = "Prod"
  costcenter  = "CT-Project01
  owner       = "april.edwards@microsoft.com
  deployed_by  = "MSDemo-terraform"
}

#################
# Prod & Dev Firewall rules
#################

prod_dev_rules_open = [
  {
    name                   = "http"
    priority               = "200"
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    destination_port_range = "80"
    source_address_prefix  = "*"
  },
  {
    name                   = "https"
    priority               = "201"
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    destination_port_range = "443"
    source_address_prefix  = "*"
  },
]

jumphost_rules_locked_down = [
    {
      name                    = "ssh"
      priority                = "200"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "22"
      source_address_prefixes = "83.166.165.252/32,83.166.160.4/32,83.166.160.231/32,109.153.25.7/32"
    },
    {
      name                    = "rdp"
      priority                = "201"
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      destination_port_range  = "3389"
      source_address_prefixes = "83.166.165.252/32,83.166.160.4/32,83.166.160.231/32"
    },
  ]

from_jumphost_rules_groups = [
    {
      name                   = "rdp"
      priority               = "300"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "3389"
    },
    {
      name                   = "ssh"
      priority               = "301"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "22"
    },
  ]


#################
# Load Balancer NAT rules
#################

lb_nat_rules = [
    {
      name          = "http"
      protocol      = "tcp"
      frontend_port = "80"
      backend_port  = "80"
    },
    {
      name          = "https"
      protocol      = "tcp"
      frontend_port = "443"
      backend_port  = "443"
    },
    {
      name          = "ftpdata"
      protocol      = "tcp"
      frontend_port = "20"
      backend_port  = "20"
    },
    {
      name          = "ftp"
      protocol      = "tcp"
      frontend_port = "21"
      backend_port  = "21"
    },
    {
      name          = "ftps"
      protocol      = "tcp"
      frontend_port = "990"
      backend_port  = "990"
    },
  ]