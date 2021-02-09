###
# Horizon NSX Micro-segmentation configuration
###

// ----- Horizon Security Tags and Groups -----

# UAG Groups
resource "nsxt_policy_group" "UAG-Groups" {
  display_name = "Horizon_UAG_SG"
  description = "Group consisting of UAG VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator  = "CONTAINS"
      key = "Tag"
      value = "horizon|horizon_uag"
    }
  }
}

resource "nsxt_policy_group" "UAG-VIP-Groups" {
  display_name = "Horizon_UAG_VIP_SG"
  description = "Group consisting of UAG VIP IP@"
  criteria {
    ipaddress_expression {
      ip_addresses = ["1.1.1.1"]
    }
  }
}

# CS Groups
resource "nsxt_policy_group" "CS-Groups" {
  display_name = "Horizon_CS_SG"
  description = "Group consisting of UAG VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator = "CONTAINS"
      key = "Tag"
      value = "horizon|horizon_cs"
    }
  }
}

resource "nsxt_policy_group" "CS-VIP-Groups" {
  display_name = "Horizon_CS_VIP_SG"
  description = "Group consisting of CS VIP IP@"
  criteria {
    ipaddress_expression {
      ip_addresses = ["1.1.1.2"]
    }
  }
}

# MSSQL Groups
resource "nsxt_policy_group" "MSSQL-Groups" {
  display_name = "Horizon_MSSQL_SG"
  description = "Group consisting of MSSQL VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator = "CONTAINS"
      key = "Tag"
      value = "horizon|horizon_mssql"
    }
  }
}

# vCenter Groups
resource "nsxt_policy_group" "vCenter-Groups" {
  display_name = "Horizon_vCenter_SG"
  description = "Group consisting of vCenter"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator = "CONTAINS"
      key = "Tag"
      value = "horizon|horizon_vCenter"
    }
  }
}

# VDI Groups
resource "nsxt_policy_group" "VDI-Groups" {
  display_name = "Horizon_VDI_SG"
  description  = "Group consisting of VDI VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator = "CONTAINS"
      key = "Tag"
      value = "horizon|horizon_vdi"
    }
  }
}

# RDSH Groups
resource "nsxt_policy_group" "RDSH-Groups" {
  display_name = "Horizon_RDSH_SG"
  description  = "Group consisting of RDSH VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator  = "CONTAINS"
      key = "Tag"
      value = "horizon|horizon_rdsh"
    }
  }
}

# AD Users Groups
resource "nsxt_policy_group" "AD-Users-Groups" {
  display_name = "Horizon_AD-Users_SG"
  description  = "Group consisting of AD Users"
  extended_criteria {
    identity_group {
      distinguished_name = "CN=IT,CN=Users,DC=ovn,DC=com"
      domain_base_distinguished_name = "CN=Users,DC=ovn,DC=com"
    }
  }
}

# Application Groups
resource "nsxt_policy_group" "WEBs-Groups" {
  display_name = "Horizon_WEBs_SG"
  description  = "Group consisting of WEBs VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "webs"
    }
  }
}