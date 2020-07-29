#
# This part of the example shows creating Groups with dynamic membership
# criteria
#

# AD Users Groups
resource "nsxt_policy_group" "AD-Users-Groups" {
  display_name = "AD-Users_SG"
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
  display_name = "WEBs_SG"
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
  display_name = "VDI_SG"
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
  display_name = "RDSH_SG"
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
  display_name = "UAG_SG"
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
resource "nsxt_policy_service" "horizon-blast-pcoip" {
  display_name = "Horizon-BLAST-PCoIP_services-443-8443-4172"
  description  = "Services for BLAST and PCoIP Horizon on port 443, 8443, and 4172"
  l4_port_set_entry {
    description       = "TCP Port 443, 8443, and 4172"
    protocol          = "TCP"
    destination_ports = ["443", "8443", "4172"]
  }
}

#
# Here we have examples of create data sources for Services
#
data "nsxt_policy_service" "https" {
  display_name = "HTTPS"
}

data "nsxt_policy_service" "rdp" {
  display_name = "RDP"
}
#
# In this section, we have example to create Firewall sections and rules
# All rules in this section will be applied to VMs that are part of the
# Gropus we created earlier
#

resource "nsxt_policy_security_policy" "web_section" {
  display_name = "Horizon - Web app Section by Terraform"
  description  = "Firewall section created by Terraform"
  category     = "Application"
  locked       = "false"
  stateful     = "true"
  sequence_number  = 3

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
    scope              = [nsxt_policy_group.WEBs-Groups.path]
  }
}

resource "nsxt_policy_security_policy" "idfw_section" {
  display_name = "Horizon - VDI/RDSH IDFW Section by Terraform"
  description  = "Firewall section created by Terraform"
  category     = "Application"
  locked       = "false"
  stateful     = "true"
  sequence_number = 2

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

resource "nsxt_policy_security_policy" "UAG_section" {
  display_name = "Horizon - UAG Section by Terraform"
  description  = "Firewall section created by Terraform"
  category     = "Application"
  locked       = "false"
  stateful     = "true"
  sequence_number = 1

  # Allow communication from any to UAG via HTTPS
  rule {
    display_name       = "Allow HTTPS"
    description        = "In going rule"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    destination_groups = [nsxt_policy_group.UAG-Groups.path]
    services           = [data.nsxt_policy_service.https.path]
    scope              = [nsxt_policy_group.UAG-Groups.path]
  }

  # Allow communication from any to UAG for BLAST and PCoIP
  rule {
    display_name       = "Allow BLAST and PCoIP traffic"
    description        = "In going rule"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    destination_groups = [nsxt_policy_group.UAG-Groups.path]
    services           = [nsxt_policy_service.horizon-blast-pcoip.path]
    scope              = [nsxt_policy_group.UAG-Groups.path]
  }

  # Reject everything else
  rule {
    display_name = "Block all"
    description  = "Default Deny the traffic"
    action       = "REJECT"
    logged       = "true"
    ip_version   = "IPV4"
    destination_groups = [nsxt_policy_group.UAG-Groups.path]
    scope              = [nsxt_policy_group.UAG-Groups.path]
  }

  # Allow communication from UAG to VDI/RDSH via RDP
  rule {
    display_name       = "Allow RDP traffic"
    description        = "In going rule"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    source_groups      = [nsxt_policy_group.UAG-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services           = [data.nsxt_policy_service.rdp.path]
    scope              = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }
}