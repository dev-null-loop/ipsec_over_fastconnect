cross_connect = {
  display_name = "testIpsecOverFCCrossConnect"
  is_active    = true
}

virtual_circuit = {
  type                 = "PRIVATE"
  bandwidth_shape_name = "100 Mbps"
  customer_asn         = "64513"
  display_name         = "testIpsecOverFCVirtualCircuit"
  cross_connect_mapping = {
    customer_bgp_peering_ip = "10.0.1.22/30"
    oracle_bgp_peering_ip   = "10.0.1.21/30"
    vlan                    = 101
  }
}
