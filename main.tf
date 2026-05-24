resource "oci_core_cpe" "this" {
  for_each            = var.cpes
  compartment_id      = var.compartment_ids[each.value.compartment_name]
  cpe_device_shape_id = each.value.cpe_device_shape_id
  defined_tags        = each.value.defined_tags
  display_name        = each.value.display_name
  freeform_tags       = each.value.freeform_tags
  ip_address          = each.value.ip_address
  is_private          = each.value.is_private
}

resource "oci_core_drg" "this" {
  for_each       = var.drgs
  compartment_id = var.compartment_ids[each.value.compartment_name]
  defined_tags   = each.value.defined_tags
  display_name   = each.value.display_name
  freeform_tags  = each.value.freeform_tags
}

resource "oci_core_ipsec" "this" {
  for_each                  = var.ipsecs
  compartment_id            = var.compartment_ids[each.value.compartment_name]
  cpe_id                    = oci_core_cpe.this[each.value.cpe_name].id
  cpe_local_identifier      = each.value.cpe_local_identifier
  cpe_local_identifier_type = each.value.cpe_local_identifier_type
  defined_tags              = each.value.defined_tags
  display_name              = each.value.display_name
  drg_id                    = oci_core_drg.this[each.value.drg_name].id
  freeform_tags             = each.value.freeform_tags
  static_routes             = each.value.static_routes
  dynamic "tunnel_configuration" {
    for_each = each.value.tunnel_configuration
    iterator = tc
    content {
      oracle_tunnel_ip            = tc.value.oracle_tunnel_ip
      associated_virtual_circuits = tc.value.associated_virtual_circuits
      drg_route_table_id          = tc.value.drg_route_table_id
    }
  }
}
