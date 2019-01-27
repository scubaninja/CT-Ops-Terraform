variable "vm_os_simple" {
  default = ""
}

# Definition of the standard OS with "SimpleName" = "publisher,offer,sku"
variable "standard_os" {
  default = {
    "WindowsServer2016" = "MicrosoftWindowsServer,WindowsServer,2016-Datacenter"
    "WindowsServer2012" = "MicrosoftWindowsServer,WindowsServer,2012-R2-Datacenter"
    "CentOS"            = "OpenLogic,CentOS,7.5"
    "RHEL"              = "RedHat,RHEL,7.5"
    "UbuntuServer"      = "Canonical,UbuntuServer,18.04-LTS"
  }
}
