ipsec = {
  static_routes             = ["10.0.0.0/16"]
  cpe_local_identifier      = "10.1.6.7"
  cpe_local_identifier_type = "IP_ADDRESS"
  display_name              = "MyIPSecConnectionOverFC"
  tunnel_configuration = [
    {
      oracle_tunnel_ip = "10.1.5.5"
    },
    {
      oracle_tunnel_ip = "10.1.7.7"
    },
  ]
}

first_tunnel_management = {
  display_name  = "MyIPSecConnectionOverFCTunnelMgmt"
  routing       = "BGP"
  shared_secret = "sharedSecret"
  ike_version   = "V1"
  bgp_session_info = {
    customer_bgp_asn        = "1587232876"
    customer_interface_ip   = "10.0.0.16/31"
    oracle_interface_ip     = "10.0.0.17/31"
    customer_interface_ipv6 = "2002:db2::6/64"
    oracle_interface_ipv6   = "2002:db2::7/64"
  }
}

second_tunnel_management = {
  display_name            = "MyIPSecConnectionOverFC-Tunnel2"
  routing                 = "POLICY"
  shared_secret           = "sharedSecret"
  ike_version             = "V1"
  nat_translation_enabled = "ENABLED"
  oracle_can_initiate     = "RESPONDER_ONLY"
  encryption_domain_config = {
    cpe_traffic_selector    = ["10.0.0.16/31", "11.0.0.16/31"]
    oracle_traffic_selector = ["12.0.0.16/31"]
  }
  phase_one_details = {
    is_custom_phase_one_config = false
    lifetime                   = 28600
  }
  phase_two_details = {
    dh_group                   = "GROUP20"
    is_custom_phase_two_config = false
    is_pfs_enabled             = true
    lifetime                   = 3602
  }
}
