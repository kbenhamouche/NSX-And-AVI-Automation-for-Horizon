
#variables required for NSX connection.

variable "nsx_server" {
  default = "10.5.99.151"
}
variable "nsx_username" {} // from Jenkins
variable "nsx_password" {} // from Jenkins

#variables required for AVI connection.

variable "avi_controller" {
  default = "10.5.99.170"
}
variable "avi_username" {} // from Jenkins
variable "avi_password" {} // from Jenkins

variable "avi_tenant" {
  default = "admin"
}

#variables required for configuration of Avi for Horizon deployment in a shared VIP with L7 and L4 Virtual Services.

variable "ipaddr_placement" {
  default = "172.58.2.0"
}

variable "mgmt_net" {
  default = "10.5.99.0"
}

variable "cloud_name" {
  default = "Default-Cloud"
}

variable "ip_vip" {
  default = "172.58.2.115"
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

variable "horizon_hm" {
  default = "Horizon-HTTPS-Health-Monitor"
}

variable "ip_group" {
  default = "Horizon-UAG-Servers-Group"
}

variable "l4_pool" {
  default = "Horizon-L4-Pool"
}

variable "l7_pool" {
  default = "Horizon-L7-Pool"
}

variable "l7_vs" {
  default = "Horizon-UAG-L7-VS"
}

variable "l4_vs" {
  default = "Horizon-UAG-L4-VS"
}

variable "horizon_wafprofile" {
  default = "Horizon_WAF_profile"
}

variable "horizon_wafpolicy" {
  default = "Horizon_WAF_policy"
}