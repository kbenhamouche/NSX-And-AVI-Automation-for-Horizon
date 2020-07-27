// Configure the NSXT provider
provider "nsxt" {
  host                     = "10.5.99.151"
  username                 = var.nsx_username
  password                 = var.nsx_password
  allow_unverified_ssl     = true
  max_retries              = 10
  retry_min_delay          = 500
  retry_max_delay          = 5000
  retry_on_status_codes    = [429]
}

// Configure the AVI provider
provider "avi" {
    avi_username   = var.avi_username
    avi_password   = var.avi_password
    avi_controller = "10.5.99.170"
    avi_tenant     = "admin"
}
