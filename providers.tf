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
