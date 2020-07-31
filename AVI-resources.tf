# This terraform can be used to configure Avi for Horizon in a Shared VIP with L7 and L4 Virtual Services.
# https://avinetworks.com/docs/18.2/configure-avi-vantage-for-vmware-horizon/

/* STEPS
1- Define the Health Monitor Template
2- Define the Group  Template for pools (optional)
3- Define Pool Servers
4- Define the VIP@
5- Define the WAF profile (optional)
6- Define the WAF policy (optional)
7- Define the Virtual Services
*/

data "avi_network" "placement_net" {
   name = var.mgmt_net
}

data "avi_sslprofile" "system-standard" {
   name = var.ssl_profile
}

data "avi_sslkeyandcertificate" "horizon_cert" {
   name = var.horizon_cert
}

data "avi_cloud" "horizon_cloud" {
   name = var.cloud_name
}

data "avi_applicationprofile" "horizon_L7app_profile" {
   name = "System-Secure-HTTP-VDI"
}

data "avi_applicationprofile" "horizon_app_profile" {
   name = var.l4_app_profile
}

data "avi_networkprofile" "system-tcp-proxy" {
   name = "System-TCP-Proxy"
}

data "avi_networkprofile" "System-UDP-Fast-Path-VDI" {
   name = "System-UDP-Fast-Path-VDI"
}

data "avi_wafprofile" "horizon_waf_profile" {
  name = "horizon_waf_profile"
}

data "avi_wafpolicy" "horizon_waf_policy" {
  name = "horizon_waf_policy"
}

// Custom Heath Monitor
resource "avi_healthmonitor" "uag-https" {
   monitor_port = 443
   https_monitor {
   http_request = "HEAD /favicon.ico HTTP/1.0"
   http_response_code = [ "HTTP_2XX", "HTTP_4XX" ]
   ssl_attributes {
      ssl_profile_ref = data.avi_sslprofile.system-standard.id
      ssl_key_and_certificate_ref = data.avi_sslkeyandcertificate.horizon_cert.id
      }
   } 
   name = var.horizon_hm
   receive_timeout = 10
   failed_checks = 3
   send_interval = 30
   type = "HEALTH_MONITOR_HTTPS"
}

// UAG IP Group
resource "avi_ipaddrgroup" "uag_ip_group" {
   name = var.ip_group
   addrs {
      addr = var.pool_server1
      type = "V4"
   }
   addrs {
      addr = var.pool_server2
      type = "V4"
   }
}

// HTTPS L7 Pool
resource "avi_pool" "https_xml-api_pool" {
   lb_algorithm = "LB_ALGORITHM_CONSISTENT_HASH"
   lb_algorithm_hash = "LB_ALGORITHM_CONSISTENT_HASH_SOURCE_IP_ADDRESS"
   cloud_ref = data.avi_cloud.horizon_cloud.id
   default_server_port = 443
   ssl_profile_ref = data.avi_sslprofile.system-standard.id
   health_monitor_refs = [
      avi_healthmonitor.uag-https.id
   ]
   ipaddrgroup_ref = avi_ipaddrgroup.uag_ip_group.id
   name = var.l7_pool
   fail_action {
    type = "FAIL_ACTION_CLOSE_CONN"
   }
   ignore_servers = true
   analytics_policy {
    enable_realtime_metrics = true
   }
}

// BLAST and PCoIP L4 Pool
resource "avi_pool" "blast_pcoip_pool" {
   lb_algorithm = "LB_ALGORITHM_CONSISTENT_HASH"
   lb_algorithm_hash = "LB_ALGORITHM_CONSISTENT_HASH_SOURCE_IP_ADDRESS"
   cloud_ref = data.avi_cloud.horizon_cloud.id
   default_server_port = 443
   use_service_port = true
   health_monitor_refs = [
      avi_healthmonitor.uag-https.id
   ]
   ipaddrgroup_ref = avi_ipaddrgroup.uag_ip_group.id
   name = var.l4_pool
}

// Shared VIP@
resource "avi_vsvip" "horizon_vsvip" {
   name = "horizon-vsvip"
   cloud_ref = data.avi_cloud.horizon_cloud.id
   vip {
      ip_address {
         addr = var.ip_vip
         type = "V4"
      }
   }
   dns_info {
      fqdn = var.domain_name
   }
}

// WAF profile
/*resource "avi_wafprofile" "horizon_waf_profile" {
  name = "horizon_waf_profile"
  config {
    learning_params {
      enable_per_uri_learning = true
      max_uris = 100
      min_hits_to_learn = 20
      sampling_percent = 100
      update_interval = 1
    }
    max_execution_time = 50
    min_confidence = "CONFIDENCE_VERY_HIGH"
    enable_auto_rule_updates = true
    //client_request_max_body_size= 1024
}

// WAF policy
resource "avi_wafpolicy" "horizon_waf_policy" {
  name = "horizon_waf_policy"
  waf_profile_ref = data.avi_wafprofile.horizon_waf_profile.id // attach the WAF profile
  enable_app_learning = false
  mode = "WAF_MODE_DETECTION_ONLY"
  paranoia_level = "WAF_MODE_LEVEL_ONLY"
  whitelist {
     rules {
         name = "Tunnel URI whitelist"
         match {
           path {
            match_criteria = "CONTAINS"
            match_str = "/ice/tunnel/"
           }
         actions = "WAF_POLICY_WHITELIST_ACTION_ALLOW"
        }
     }
   }
}*/

// L7 Virtual Service with WAF
resource "avi_virtualservice" "https_xml-api_VS" {
   name = var.l7_vs
   services {
      port = 443
      enable_ssl = true
   }
   pool_ref = avi_pool.https_xml-api_pool.id
   application_profile_ref = data.avi_applicationprofile.horizon_L7app_profile.id
   ssl_profile_ref = data.avi_sslprofile.system-standard.id
   ssl_key_and_certificate_refs = [data.avi_sslkeyandcertificate.horizon_cert.id]
   network_profile_ref = data.avi_networkprofile.system-tcp-proxy.id
   cloud_ref = data.avi_cloud.horizon_cloud.id
   vsvip_ref = avi_vsvip.horizon_vsvip.id
   //waf_policy_ref = data.avi_wafpolicy.horizon_waf_policy.id //WAF config
   analytics_policy {
    metrics_realtime_update {
      enabled  = true
      duration = 0
    }
  }
}

// L4 Virtual Service
resource "avi_virtualservice" "blast_pcoip_VS" {
   name = var.l4_vs
   services {
      port = 8443
   }
   services {
      port = 8443
      override_network_profile_ref = data.avi_networkprofile.System-UDP-Fast-Path-VDI.id
   }
   services {
      port = 4172
   }
   services {
      port = 4172
      override_network_profile_ref = data.avi_networkprofile.System-UDP-Fast-Path-VDI.id
   }
   services {
      port = 443
      override_network_profile_ref = data.avi_networkprofile.System-UDP-Fast-Path-VDI.id
   }
   application_profile_ref = data.avi_applicationprofile.horizon_app_profile.id
   pool_ref = avi_pool.blast_pcoip_pool.id
   network_profile_ref = data.avi_networkprofile.system-tcp-proxy.id
   cloud_ref = data.avi_cloud.horizon_cloud.id
   vsvip_ref = avi_vsvip.horizon_vsvip.id
}