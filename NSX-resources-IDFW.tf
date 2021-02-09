###
# Horizon NSX Micro-segmentation configuration
###

// ----- IDFW - Security -----

resource "nsxt_policy_security_policy" "idfw_section" {
  display_name = "Horizon - IDFW Section"
  category     = "Application"
  locked       = "false"
  stateful     = "true"
  sequence_number = 7

  # Allow communication from AD Users to Webs via HTTPS
  rule {
    display_name       = "Allow HTTPS"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    source_groups      = [nsxt_policy_group.AD-Users-Groups.path]
    destination_groups = [nsxt_policy_group.WEBs-Groups.path]
    services           = [data.nsxt_policy_service.https.path]
    scope              = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Reject everything else
  rule {
    display_name = "Block all"
    action       = "REJECT"
    logged       = "true"
    ip_version   = "IPV4"
    destination_groups = [nsxt_policy_group.WEBs-Groups.path]
    scope              = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }
}

resource "nsxt_policy_security_policy" "WEB_section" {
  display_name = "Horizon - WEB Application Section"
  category     = "Application"
  locked       = "false"
  stateful     = "true"
  sequence_number = 8

   # Allow communication from VDI/RDSH to Webs via HTTPS
  rule {
    display_name       = "Allow HTTPS"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    source_groups      = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    destination_groups = [nsxt_policy_group.WEBs-Groups.path]
    services           = [data.nsxt_policy_service.https.path]
    scope              = [nsxt_policy_group.WEBs-Groups.path]
  }
}



