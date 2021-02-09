###
# Horizon NSX Micro-segmentation configuration
###

// ----- Horizon External Access - Security -----
resource "nsxt_policy_security_policy" "External_section" {
  display_name = "Horizon External Access Section"
  category = "Application"
  locked = "false"
  stateful = "true"
  sequence_number = 1

  # Allow communication from any to UAG VIP via HTTPS
  rule {
    display_name = "Horizon client to UAG HTTPS"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    services = [data.nsxt_policy_service.https.path]
    profiles = [data.nsxt_policy_context_profile.ssl.path]
    scope = [nsxt_policy_group.UAG-Groups.path]
  }

  # Allow communication from any to UAG VIP for PCoIP
  rule {
    display_name = "Horizon client to UAG PCoIP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    services = [data.nsxt_policy_service.pcoip-udp.path, data.nsxt_policy_service.pcoip-tcp.path]
    profiles = [data.nsxt_policy_context_profile.pcoip.path]
    scope = [nsxt_policy_group.UAG-Groups.path]
  }

  # Allow communication from any to UAG VIP for Blast
  rule {
    display_name = "Horizon client to UAG Blast"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    services = [nsxt_policy_service.Horizon-blast-service.path]
    profiles = [data.nsxt_policy_context_profile.blast.path]
    scope = [nsxt_policy_group.UAG-Groups.path]
  }
}

// ----- Horizon Internal Access - Security -----
resource "nsxt_policy_security_policy" "Internal_section" {
  display_name = "Horizon Internal Access Section"
  category = "Application"
  locked = "false"
  stateful = "true"
  sequence_number = 2

  # Allow communication from any to VDI and RDSH for PCoIP
  rule {
    display_name = "Horizon client to Agent via PCoIP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [data.nsxt_policy_service.pcoip-udp.path, data.nsxt_policy_service.pcoip-tcp.path]
    profiles = [data.nsxt_policy_context_profile.pcoip.path]
    scope = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from any to VDI and RDSH via Blast
  rule {
    display_name = "Horizon client to Agent via Blast Extreme"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-blast-extreme-service.path]
    profiles = [data.nsxt_policy_context_profile.blast.path]
    scope = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from any to VDI and RDSH via RDP
  rule {
    display_name = "Horizon client to Agent via RDP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [data.nsxt_policy_service.rdp.path]
    profiles = [data.nsxt_policy_context_profile.rdp.path]
    scope = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from any to VDI and RDSH via CDR MMR
  rule {
    display_name = "Horizon client to Agent via CDR MMR"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-cdr-mmr-service.path]
    scope = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from any to VDI and RDSH for USB redirection
  rule {
    display_name = "Horizon client to Agent USB redirection"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-32111-service.path]
    scope = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from any to CS VIP via HTTPS-8443
  rule {
    display_name = "Horizon client to CS HTML Access"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.CS-VIP-Groups.path]
    services = [nsxt_policy_service.Horizon-HTTPS-8443-service.path]
    profiles = [data.nsxt_policy_context_profile.ssl.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }

  # Allow communication from any to CS VIP via HTTP
  rule {
    display_name = "Horizon client to CS via HTTP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.CS-VIP-Groups.path]
    services = [data.nsxt_policy_service.http.path]
    profiles = [data.nsxt_policy_context_profile.http.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }

  # Allow communication from any to CS VIP via HTTPS
  rule {
    display_name = "Horizon client to CS via HTTPS"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    destination_groups = [nsxt_policy_group.CS-VIP-Groups.path]
    services = [data.nsxt_policy_service.https.path]
    profiles = [data.nsxt_policy_context_profile.ssl.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }
}

// ----- Horizon UAG - Security -----
resource "nsxt_policy_security_policy" "UAG_section" {
  display_name = "Horizon UAG Section"
  category = "Application"
  locked = "false"
  stateful = "true"
  sequence_number = 3

  # Allow communication from UAG to CS VIP via HTTPS
  rule {
    display_name = "UAG to CS VIP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.UAG-Groups.path]
    destination_groups = [nsxt_policy_group.CS-VIP-Groups.path]
    services = [data.nsxt_policy_service.https.path]
    profiles = [data.nsxt_policy_context_profile.ssl.path]
    scope = [nsxt_policy_group.UAG-Groups.path, nsxt_policy_group.CS-VIP-Groups.path]
  }

  # Allow communication from UAG to VDI and RDSH via Blast
  rule {
    display_name = "UAG VIP to Agent via Blast Extreme"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-blast-extreme-service.path]
    profiles = [data.nsxt_policy_context_profile.blast.path]
    scope = [nsxt_policy_group.UAG-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from UAG to VDI and RDSH for PCoIP
  rule {
    display_name = "UAG VIP to Agent via PCoIP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [data.nsxt_policy_service.pcoip-udp.path, data.nsxt_policy_service.pcoip-tcp.path]
    profiles = [data.nsxt_policy_context_profile.pcoip.path]
    scope = [nsxt_policy_group.UAG-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from UAG to VDI and RDSH via RDP
  rule {
    display_name = "UAG VIP to Agent via RDP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [data.nsxt_policy_service.rdp.path]
    profiles = [data.nsxt_policy_context_profile.rdp.path]
    scope = [nsxt_policy_group.UAG-VIP-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from UAG to VDI and RDSH via CDR MMR
  rule {
    display_name = "UAG VIP to Agent via CDR MMR"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-cdr-mmr-service.path]
    scope = [nsxt_policy_group.UAG-VIP-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from UAG to VDI and RDSH for USB redirection
  rule {
    display_name = "UAG VIP to Agent USB redirection"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.UAG-VIP-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-32111-service.path]
    scope = [nsxt_policy_group.UAG-VIP-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }
}

// ----- Horizon CS - Security -----
resource "nsxt_policy_security_policy" "CS_section" {
  display_name = "Horizon CS Section"
  category = "Application"
  locked = "false"
  stateful = "true"
  sequence_number = 4

  # Allow communication from CS to MSSQL
  rule {
    display_name = "CS to MSSQL"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.MSSQL-Groups.path]
    services = [nsxt_policy_service.Horizon-mssql.path]
    profiles = [data.nsxt_policy_context_profile.mssql.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.MSSQL-Groups.path]
  }

  # Allow communication from CS to VDI and RDSH via Blast
  rule {
    display_name = "CS to Agent via Blast Extreme"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-blast-22443-service.path]
    profiles = [data.nsxt_policy_context_profile.blast.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from CS to VDI and RDSH for PCoIP
  rule {
    display_name = "CS to Agent via PCoIP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [data.nsxt_policy_service.pcoip-udp.path, data.nsxt_policy_service.pcoip-tcp.path]
    profiles = [data.nsxt_policy_context_profile.pcoip.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from CS to VDI and RDSH via RDP
  rule {
    display_name = "CS to Agent via RDP"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [data.nsxt_policy_service.rdp.path]
    profiles = [data.nsxt_policy_context_profile.rdp.path]
    scope = [nsxt_policy_group.UAG-VIP-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from CS to VDI and RDSH via CDR MMR
  rule {
    display_name = "CS to Agent via CDR MMR"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-cdr-mmr-service.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from CS to VDI and RDSH for USB redirection
  rule {
    display_name = "CS to Agent USB redirection"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
    services = [nsxt_policy_service.Horizon-32111-service.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.VDI-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }

  # Allow communication from CS to vCenter via Blast
  rule {
    display_name = "CS to vCenter via Blast Extreme"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.vCenter-Groups.path]
    services = [nsxt_policy_service.Horizon-blast-22443-service.path]
    profiles = [data.nsxt_policy_context_profile.blast.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.vCenter-Groups.path]
  }
  
  # Allow communication from JMS CS to CS Legacy
  rule {
    display_name = "JMS CS to CS Legacy"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.CS-Groups.path]
    services = [nsxt_policy_service.Horizon-jms-legacy.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }

  # Allow communication from JMS CS to CS SSL
  rule {
    display_name = "JMS CS to CS SSL"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.CS-Groups.path]
    services = [nsxt_policy_service.Horizon-jms-ssl.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }

  # Allow communication from CS to CS Replica
  rule {
    display_name = "CS to CS Replica"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.CS-Groups.path]
    services = [nsxt_policy_service.Horizon-replica.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }

  # Allow communication from CS to CS MS-RPC
  rule {
    display_name = "CS to CS MS-RPC"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.CS-Groups.path]
    destination_groups = [nsxt_policy_group.CS-Groups.path]
    services = [nsxt_policy_service.Horizon-alg.path]
    scope = [nsxt_policy_group.CS-Groups.path]
  }
}

// ----- Horizon VDI- Security -----
resource "nsxt_policy_security_policy" "VDI_section" {
  display_name = "Horizon VDI Section"
  category = "Application"
  locked = "false"
  stateful = "true"
  sequence_number = 5

  # Allow communication from VDI to CS
  rule {
    display_name = "VDI to CS"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.VDI-Groups.path]
    destination_groups = [nsxt_policy_group.CS-Groups.path]
    services = [nsxt_policy_service.Horizon-jms-enhanced.path, nsxt_policy_service.Horizon-jms-legacy-4001.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.VDI-Groups.path]
  }
}

// ----- Horizon RDSH - Security -----
resource "nsxt_policy_security_policy" "RDSH_section" {
  display_name = "Horizon RDSH Section"
  category = "Application"
  locked = "false"
  stateful = "true"
  sequence_number = 6

  # Allow communication from RDSH to CS
  rule {
    display_name = "RDSH to CS"
    action = "ALLOW"
    logged = "false"
    ip_version = "IPV4"
    source_groups = [nsxt_policy_group.RDSH-Groups.path]
    destination_groups = [nsxt_policy_group.CS-Groups.path]
    services = [nsxt_policy_service.Horizon-jms-enhanced.path, nsxt_policy_service.Horizon-jms-legacy-4001.path]
    scope = [nsxt_policy_group.CS-Groups.path, nsxt_policy_group.RDSH-Groups.path]
  }
}

