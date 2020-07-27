
#variables required for NSX connection.

variable "nsx_server" {
  default = "10.5.99.151"
}
variable "nsx_username" {}
variable "nsx_password" {}

#variables required for AVI connection.

variable "avi_controller" {
  default = "10.5.99.170"
}
variable "avi_username" {}
variable "avi_password" {}

variable "avi_tenant" {
  default = "admin"
}

#variables required for configuration of Avi for Horizon deployment in a shared VIP with L7 and L4 Virtual Services.

variable "ipaddr_placement" {
  default = "10.5.99.151"
}

variable "mgmt_net" {
  default = "10.5.99.0"
}

variable "cloud_name" {
  default = "Default-Cloud"
}

variable "ip_vip" {
  default = "172.58.2.110"
}

variable "domain_name" {
  default = "horizon.ovn.ca"
}

variable "pool_server1" {
  default = "172.51.0.132"
}

variable "pool_server2" {
  default = "172.51.0.165"
}

variable "app_profile" {
  default = "System-Secure-HTTP"
}
  
variable "horizon_cert" {
  default = "System-Default-Cert"
}

variable "horizon_hm" {
  default = "Horizon-Health-Monitor"
}

variable "ip_group" {
  default = "Horizon-UAG-Pool"
}

variable "ssl_profile" {
  default = "System-Standard"
}

variable "l4_pool" {
  default = "Horizon-UAG-L4-Pool"
}

variable "l4_app_profile" {
  default = "System-L4-Application"
}

variable "l7_pool" {
  default = "Horizon-UAG-L7-Pool"
}

variable "l7_vs" {
  default = "Horizon-L7-VS"
}
variable "l4_vs" {
  default = "Horizon-L4-VS"
}