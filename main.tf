data "oci_core_cpe_device_shapes" "this" {}

data "oci_core_cpe_device_shape" "this" {
  cpe_device_shape_id = local.resolved_cpe_device_shape_id
}

data "oci_core_cross_connect_locations" "this" {
  compartment_id = local.compartment_id
}

data "oci_core_cross_connect_port_speed_shapes" "this" {
  compartment_id = local.compartment_id
}

resource "oci_core_cpe" "this" {
  compartment_id      = local.compartment_id
  display_name        = var.cpe.display_name
  ip_address          = var.cpe.ip_address
  cpe_device_shape_id = data.oci_core_cpe_device_shape.this.id
  is_private          = var.cpe.is_private
  defined_tags        = var.cpe.defined_tags
  freeform_tags       = var.cpe.freeform_tags
}

resource "oci_core_drg" "this" {
  compartment_id = local.compartment_id
  display_name   = var.drg.display_name
  defined_tags   = var.drg.defined_tags
  freeform_tags  = var.drg.freeform_tags
}

resource "oci_core_drg_route_table" "this" {
  drg_id       = oci_core_drg.this.id
  display_name = var.drg_route_table.display_name
}

resource "oci_core_cross_connect" "this" {
  compartment_id                               = local.compartment_id
  location_name                                = local.resolved_cross_connect_location_name
  port_speed_shape_name                        = local.resolved_cross_connect_port_speed_name
  display_name                                 = var.cross_connect.display_name
  is_active                                    = var.cross_connect.is_active
  cross_connect_group_id                       = var.cross_connect.cross_connect_group_id
  customer_reference_name                      = var.cross_connect.customer_reference_name
  far_cross_connect_or_cross_connect_group_id  = var.cross_connect.far_cross_connect_or_cross_connect_group_id
  near_cross_connect_or_cross_connect_group_id = var.cross_connect.near_cross_connect_or_cross_connect_group_id
  defined_tags                                 = var.cross_connect.defined_tags
  freeform_tags                                = var.cross_connect.freeform_tags
}

resource "oci_core_virtual_circuit" "this" {
  compartment_id       = local.compartment_id
  type                 = var.virtual_circuit.type
  bandwidth_shape_name = var.virtual_circuit.bandwidth_shape_name
  customer_asn         = var.virtual_circuit.customer_asn
  display_name         = var.virtual_circuit.display_name
  gateway_id           = oci_core_drg.this.id
  cross_connect_mappings {
    cross_connect_or_cross_connect_group_id = oci_core_cross_connect.this.id
    vlan                                    = var.virtual_circuit.cross_connect_mapping.vlan
    oracle_bgp_peering_ip                   = var.virtual_circuit.cross_connect_mapping.oracle_bgp_peering_ip
    customer_bgp_peering_ip                 = var.virtual_circuit.cross_connect_mapping.customer_bgp_peering_ip
    bgp_md5auth_key                         = var.virtual_circuit.cross_connect_mapping.bgp_md5auth_key
    oracle_bgp_peering_ipv6                 = var.virtual_circuit.cross_connect_mapping.oracle_bgp_peering_ipv6
    customer_bgp_peering_ipv6               = var.virtual_circuit.cross_connect_mapping.customer_bgp_peering_ipv6
  }
}

resource "oci_core_ipsec" "this" {
  compartment_id            = local.compartment_id
  cpe_id                    = oci_core_cpe.this.id
  drg_id                    = oci_core_drg.this.id
  static_routes             = var.ipsec.static_routes
  cpe_local_identifier      = var.ipsec.cpe_local_identifier
  cpe_local_identifier_type = var.ipsec.cpe_local_identifier_type
  display_name              = var.ipsec.display_name
  defined_tags              = var.ipsec.defined_tags
  freeform_tags             = var.ipsec.freeform_tags
  dynamic "tunnel_configuration" {
    for_each = var.ipsec.tunnel_configuration
    iterator = tc
    content {
      oracle_tunnel_ip            = tc.value.oracle_tunnel_ip
      associated_virtual_circuits = [oci_core_virtual_circuit.this.id]
      drg_route_table_id          = oci_core_drg_route_table.this.id
    }
  }
}

data "oci_core_ipsec_connections" "this" {
  compartment_id = local.compartment_id
  cpe_id         = oci_core_cpe.this.id
  drg_id         = oci_core_drg.this.id
}

data "oci_core_ipsec_connection_tunnels" "this" {
  ipsec_id = oci_core_ipsec.this.id
}

data "oci_core_ipsec_connection_tunnel" "this" {
  ipsec_id  = oci_core_ipsec.this.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.this.ip_sec_connection_tunnels[0].id
}

resource "oci_core_ipsec_connection_tunnel_management" "first" {
  ipsec_id      = oci_core_ipsec.this.id
  tunnel_id     = data.oci_core_ipsec_connection_tunnels.this.ip_sec_connection_tunnels[0].id
  display_name  = var.first_tunnel_management.display_name
  routing       = var.first_tunnel_management.routing
  shared_secret = var.first_tunnel_management.shared_secret
  ike_version   = var.first_tunnel_management.ike_version
  bgp_session_info {
    customer_bgp_asn        = var.first_tunnel_management.bgp_session_info.customer_bgp_asn
    customer_interface_ip   = var.first_tunnel_management.bgp_session_info.customer_interface_ip
    oracle_interface_ip     = var.first_tunnel_management.bgp_session_info.oracle_interface_ip
    customer_interface_ipv6 = var.first_tunnel_management.bgp_session_info.customer_interface_ipv6
    oracle_interface_ipv6   = var.first_tunnel_management.bgp_session_info.oracle_interface_ipv6
  }
}

resource "oci_core_ipsec_connection_tunnel_management" "second" {
  ipsec_id                = oci_core_ipsec.this.id
  tunnel_id               = data.oci_core_ipsec_connection_tunnels.this.ip_sec_connection_tunnels[1].id
  display_name            = var.second_tunnel_management.display_name
  routing                 = var.second_tunnel_management.routing
  shared_secret           = var.second_tunnel_management.shared_secret
  ike_version             = var.second_tunnel_management.ike_version
  nat_translation_enabled = var.second_tunnel_management.nat_translation_enabled
  oracle_can_initiate     = var.second_tunnel_management.oracle_can_initiate
  encryption_domain_config {
    cpe_traffic_selector    = var.second_tunnel_management.encryption_domain_config.cpe_traffic_selector
    oracle_traffic_selector = var.second_tunnel_management.encryption_domain_config.oracle_traffic_selector
  }
  phase_one_details {
    is_custom_phase_one_config = var.second_tunnel_management.phase_one_details.is_custom_phase_one_config
    lifetime                   = var.second_tunnel_management.phase_one_details.lifetime
  }
  phase_two_details {
    dh_group                   = var.second_tunnel_management.phase_two_details.dh_group
    is_custom_phase_two_config = var.second_tunnel_management.phase_two_details.is_custom_phase_two_config
    is_pfs_enabled             = var.second_tunnel_management.phase_two_details.is_pfs_enabled
    lifetime                   = var.second_tunnel_management.phase_two_details.lifetime
  }
}

data "oci_core_ipsec_connection_tunnel_routes" "this" {
  ipsec_id   = oci_core_ipsec.this.id
  tunnel_id  = data.oci_core_ipsec_connection_tunnels.this.ip_sec_connection_tunnels[0].id
  advertiser = var.ipsec_connection_tunnel_route_advertiser
}
