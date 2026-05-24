locals {
  compartment_id                         = var.compartment_ids[var.compartment_name]
  resolved_cpe_device_shape_id           = var.cpe_device_shape_id != null ? var.cpe_device_shape_id : data.oci_core_cpe_device_shapes.this.cpe_device_shapes[0].cpe_device_shape_id
  resolved_cross_connect_location_name   = var.cross_connect_location_name != null ? var.cross_connect_location_name : data.oci_core_cross_connect_locations.this.cross_connect_locations[0].name
  resolved_cross_connect_port_speed_name = var.cross_connect_port_speed_shape_name != null ? var.cross_connect_port_speed_shape_name : data.oci_core_cross_connect_port_speed_shapes.this.cross_connect_port_speed_shapes[0].name
}

check "known_compartment" {
  assert {
    condition     = contains(keys(var.compartment_ids), var.compartment_name)
    error_message = "compartment_name must exist in compartment_ids."
  }
}

check "cpe_device_shapes_loaded" {
  assert {
    condition     = var.cpe_device_shape_id != null || length(data.oci_core_cpe_device_shapes.this.cpe_device_shapes) > 0
    error_message = "OCI returned no CPE device shapes and cpe_device_shape_id was not provided."
  }
}

check "cross_connect_locations_loaded" {
  assert {
    condition     = var.cross_connect_location_name != null || length(data.oci_core_cross_connect_locations.this.cross_connect_locations) > 0
    error_message = "OCI returned no cross-connect locations and cross_connect_location_name was not provided."
  }
}

check "cross_connect_port_speed_shapes_loaded" {
  assert {
    condition     = var.cross_connect_port_speed_shape_name != null || length(data.oci_core_cross_connect_port_speed_shapes.this.cross_connect_port_speed_shapes) > 0
    error_message = "OCI returned no cross-connect port speed shapes and cross_connect_port_speed_shape_name was not provided."
  }
}
