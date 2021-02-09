###
# Horizon NSX Micro-segmentation configuration
###

// ----- Horizon External Access - Services -----

# Use existing Context Profiles
data "nsxt_policy_context_profile" "ssl" {
  display_name = "SSL"
}

data "nsxt_policy_context_profile" "blast" {
  display_name = "BLAST"
}

data "nsxt_policy_context_profile" "pcoip" {
  display_name = "PCOIP"
}

# Use existing Services
data "nsxt_policy_service" "https" {
  display_name = "HTTPS"
}

data "nsxt_policy_service" "pcoip-udp" {
  display_name = "VMware-View5.x-PCoIP-UDP"
}

data "nsxt_policy_service" "pcoip-tcp" {
  display_name = "VMware-View-PCoIP"
}

# Define Horizon Services for External
resource "nsxt_policy_service" "Horizon-blast-service" {
  display_name = "Horizon-BLAST-443-8443"
  description  = "Services for BLAST Horizon on port 443 and 8443"
  l4_port_set_entry {
    description = "TCP Port 443, 8443"
    protocol = "TCP"
    destination_ports = ["443", "8443"]
  }
  l4_port_set_entry {
    description = "UDP Port 443, 8443"
    protocol = "UDP"
    destination_ports = ["443", "8443"]
  }
}

// ----- Horizon Internal Access and UAG - Services -----

# Use existing Context Profiles
data "nsxt_policy_context_profile" "rdp" {
  display_name = "RDP"
}

data "nsxt_policy_context_profile" "http" {
  display_name = "HTTP"
}

# Use existing Services
data "nsxt_policy_service" "rdp" {
  display_name = "RDP"
}

data "nsxt_policy_service" "http" {
  display_name = "HTTP"
}

# Define Horizon Services for Internal
resource "nsxt_policy_service" "Horizon-blast-extreme-service" {
  display_name = "Horizon-BLAST-22442-22443"
  description  = "Services for BLAST on port 22443 and 22442"
  l4_port_set_entry {
    description = "TCP Port 22443"
    protocol = "TCP"
    destination_ports = ["22443"]
  }
  l4_port_set_entry {
    description = "UDP Port 22442"
    protocol = "UDP"
    destination_ports = ["22442"]
  }
}

resource "nsxt_policy_service" "Horizon-cdr-mmr-service" {
  display_name = "Horizon-CDR-MMR"
  description  = "Services for CDR MMR on port 9427"
  l4_port_set_entry {
    description = "TCP Port 9427"
    protocol = "TCP"
    destination_ports = ["9427"]
  }
}

resource "nsxt_policy_service" "Horizon-32111-service" {
  display_name = "Horizon-32111"
  description  = "Services on port 32111"
  l4_port_set_entry {
    description = "TCP Port 32111"
    protocol = "TCP"
    destination_ports = ["32111"]
  }
}

resource "nsxt_policy_service" "Horizon-HTTPS-8443-service" {
  display_name = "Horizon-HTTPS-8443"
  description  = "Services HTTPS on port 8443"
  l4_port_set_entry {
    description = "TCP Port 8443"
    protocol = "TCP"
    destination_ports = ["8443"]
  }
}

// ----- Horizon CS - Services -----

# Use existing Context Profiles
data "nsxt_policy_context_profile" "mssql" {
  display_name = "MSSQL"
}

# Define Horizon Services
resource "nsxt_policy_service" "Horizon-mssql" {
  display_name = "Horizon-MSSQL"
  description  = "Services for MSSQL on port 1433"
  l4_port_set_entry {
    description = "TCP Port 1433"
    protocol = "TCP"
    destination_ports = ["1433"]
  }
}

resource "nsxt_policy_service" "Horizon-alg" {
  display_name = "Horizon-ALG"
  description  = "Services for ALG on port 135"
  l4_port_set_entry {
    description = "TCP Port 135"
    protocol = "TCP"
    destination_ports = ["135"]
  }
}

resource "nsxt_policy_service" "Horizon-blast-22443-service" {
  display_name = "Horizon-BLAST-22443"
  description  = "Services for BLAST on port 22443"
  l4_port_set_entry {
    description = "TCP Port 22443"
    protocol = "TCP"
    destination_ports = ["22443"]
  }
  l4_port_set_entry {
    description = "UDP Port 22443"
    protocol = "UDP"
    destination_ports = ["22443"]
  }
}

resource "nsxt_policy_service" "Horizon-jms-legacy" {
  display_name = "Horizon-JMS-LEGACY"
  description  = "Services for JMS Legacy on port 4100"
  l4_port_set_entry {
    description = "TCP Port 4100"
    protocol = "TCP"
    destination_ports = ["4100"]
  }
}

resource "nsxt_policy_service" "Horizon-jms-ssl" {
  display_name = "Horizon-JMS-SSL"
  description  = "Services for JMS SSL on port 4101"
  l4_port_set_entry {
    description = "TCP Port 4101"
    protocol = "TCP"
    destination_ports = ["4101"]
  }
}

resource "nsxt_policy_service" "Horizon-replica" {
  display_name = "Horizon-Replica"
  description  = "Services for Replica on port 389"
  l4_port_set_entry {
    description = "TCP Port 389"
    protocol = "TCP"
    destination_ports = ["389"]
  }
}

// ----- Horizon VDI - Services -----
resource "nsxt_policy_service" "Horizon-jms-enhanced" {
  display_name = "Horizon-JMS-ENHANCED"
  description  = "Services for JMS ENHANCED on port 4002"
  l4_port_set_entry {
    description = "TCP Port 4002"
    protocol = "TCP"
    destination_ports = ["4002"]
  }
}

resource "nsxt_policy_service" "Horizon-jms-legacy-4001" {
  display_name = "Horizon-JMS-LEGACY-4001"
  description  = "Services for JMS Legacy on port 4001"
  l4_port_set_entry {
    description = "TCP Port 4001"
    protocol = "TCP"
    destination_ports = ["4001"]
  }
}

// ----- Horizon RDSH - Services -----

// ----- Horizon RDSH - Security -----




