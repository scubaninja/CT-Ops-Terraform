#################
# The variables used for main.tf
#################

variable "resource_group_name" {
  description = "Name of the resource group we will be creating"
  default     = ""
}

variable "location" {
  description = "Which region in Azure are we launching the resources"
  default     = ""
}

variable "default_tags" {
  description = "The defaults tags, we will be adding to the these"
  type        = "map"
  default     = {}
}

variable "prod_dev_rules_open" {
  description = "The rules for the Network Secuuity Group which open to ports to everyone, these are here as we need to use them in more than one place"
  type        = "list"
  default     = []
}

variable "dev_rules_locked_down" {
  description = "The Group rules for the Network Secuuity Group, these are here as we need to use them in more than one place"
  type        = "list"
  default     = []
}

variable "jumphost_rules_locked_down" {
  description = "The rules which allow access to the jumphosts"
  type        = "list"
  default     = []
}

variable "from_jumphost_rules_groups" {
  description = "The rules which allow access from the jumphosts"
  type        = "list"
  default     = []
}

variable "lb_nat_rules" {
  description = "The NAT rules for the Load Balancer, these are here as we need to use them in more than one place"
  type        = "list"
  default     = []
}
