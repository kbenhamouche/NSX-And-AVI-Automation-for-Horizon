#
# This part of the example shows creating Groups with dynamic membership
# criteria
#

# All WEB VMs
resource "nsxt_policy_group" "AD-Users-Groups" {
  display_name = "AD-Users_VMs"
  description  = "Group consisting of AD Users"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "ad-users"
    }
  }
  tag {
    scope = "horizon"
    tag   = "ad-users"
  }
}

resource "nsxt_policy_group" "WEBs-Groups" {
  display_name = "WEBs_VMs"
  description  = "Group consisting of WEBs VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "webs"
    }
  }
  tag {
    scope = "horizon"
    tag   = "webs"
  }
}

resource "nsxt_policy_group" "VDI-Groups" {
  display_name = "VDI_VMs"
  description  = "Group consisting of VDI VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "vdi"
    }
  }
  tag {
    scope = "horizon"
    tag   = "vdi"
  }
}

resource "nsxt_policy_group" "RDSH-Groups" {
  display_name = "RDSH_VMs"
  description  = "Group consisting of RDSH VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "rdsh"
    }
  }
  tag {
    scope = "horizon"
    tag   = "rdsh"
  }
}

resource "nsxt_policy_group" "UAG-Groups" {
  display_name = "UAG_VMs"
  description  = "Group consisting of UAG VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "uag"
    }
  }
  tag {
    scope = "horizon"
    tag   = "uag"
  }
}

#
# An example for Service for App that listens on port 8443
#
resource "nsxt_policy_service" "8443_service" {
  display_name = "app_service_8443"
  description  = "Service for Horizon that listens on port 8443"
  l4_port_set_entry {
    description       = "TCP Port 8443"
    protocol          = "TCP"
    destination_ports = ["8443"]
  }
}

#
# Here we have examples of create data sources for Services
#
data "nsxt_policy_service" "https" {
  display_name = "HTTPS"
}

#
# In this section, we have example to create Firewall sections and rules
# All rules in this section will be applied to VMs that are part of the
# Gropus we created earlier
#
resource "nsxt_policy_security_policy" "firewall_section" {
  display_name = "Horizon VDI/RDSH IDFW Section by Terraform"
  description  = "Firewall section created by Terraform"
  category     = "Application"
  locked       = "false"
  stateful     = "true"

  # Allow communication from AD Users to Webs via HTTPS
  rule {
    display_name       = "Allow HTTPS"
    description        = "In going rule"
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
    description  = "Default Deny the traffic"
    action       = "REJECT"
    logged       = "true"
    ip_version   = "IPV4"
    destination_groups = [nsxt_policy_group.WEBs-Groups.path]
    scope              = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }
}

resource "nsxt_policy_security_policy" "firewall_section" {
  display_name = "Web app Section by Terraform"
  description  = "Firewall section created by Terraform"
  category     = "Application"
  locked       = "false"
  stateful     = "true"

  # Allow communication from VDI/RDSH to Webs via HTTPS
  rule {
    display_name       = "Allow HTTPS"
    description        = "In going rule"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    source_groups      = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    destination_groups = [nsxt_policy_group.WEBs-Groups.path]
    services           = [data.nsxt_policy_service.https.path]
    scope              = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }
}
