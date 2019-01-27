variable "resource_group_name" {
  description = "The name of the resource group we want to use"
  default     = ""
}

variable "location" {
  description = "The location/region where we are crrating the resource"
  default     = ""
}

variable "tags" {
  description = "The tags to associate the resource we are creating"
  type        = "map"
  default     = {}
}

# Everything below is for the module

variable "name" {
  description = "Hostname for the VM"
  default     = ""
}

variable "username" {
  description = "Username to use on the VM"
  default     = ""
}

variable "password" {
  description = "Password to use on the VM"
  default     = ""
}

variable "nics" {
  description = "The IDs of the NICs we want to attached to the VM"
  type        = "list"
  default     = []
}

variable "os" {
  description = "What OS to use? [WindowsServer2016,WindowsServer2012,CentOS,RHEL or UbuntuServer]"
  default     = "CentOS"
}

variable "os_version" {
  description = "What version of the image should we use, proably just want to leave this at the default"
  default     = "latest"
}

variable "vm_size" {
  description = "What size instance do we want to launch?"
  default     = "Standard_B1s"
}

variable "os_disk_name" {
  description = "name of the disk, this is appended to the vm name"
  default     = "disk1"
}

variable "os_disk_type" {
  description = "what type of the os disk?"
  default     = "Standard_LRS"
}

variable "os_disk_size" {
  description = "Size of the os disk"
  default     = "100"
}

variable "nb_instances" {
  description = "This is used to decide if a VM should be created, leave at the default value"
  default     = "1"
}
