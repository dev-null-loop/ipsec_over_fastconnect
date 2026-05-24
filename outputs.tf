output "cpe" {
  description = "Created CPE."
  value = {
    id         = oci_core_cpe.this.id
    ip_address = oci_core_cpe.this.ip_address
    is_private = oci_core_cpe.this.is_private
  }
}

output "drg" {
  description = "Created DRG."
  value = {
    id           = oci_core_drg.this.id
    display_name = oci_core_drg.this.display_name
    state        = oci_core_drg.this.state
  }
}

output "drg_route_table" {
  description = "Created DRG route table."
  value = {
    id           = oci_core_drg_route_table.this.id
    display_name = oci_core_drg_route_table.this.display_name
  }
}

output "cross_connect" {
  description = "Created cross-connect."
  value = {
    id            = oci_core_cross_connect.this.id
    display_name  = oci_core_cross_connect.this.display_name
    location_name = oci_core_cross_connect.this.location_name
  }
}

output "virtual_circuit" {
  description = "Created virtual circuit."
  value = {
    id           = oci_core_virtual_circuit.this.id
    display_name = oci_core_virtual_circuit.this.display_name
  }
}

output "ipsec" {
  description = "Created private IPSec connection."
  value = {
    id                   = oci_core_ipsec.this.id
    display_name         = oci_core_ipsec.this.display_name
    transport_type       = oci_core_ipsec.this.transport_type
    tunnel_configuration = oci_core_ipsec.this.tunnel_configuration
  }
}

output "ipsec_connections" {
  description = "IPSec connections data source response."
  value       = data.oci_core_ipsec_connections.this.connections
}

output "ipsec_connection_tunnels" {
  description = "IPSec tunnel list data source response."
  value       = data.oci_core_ipsec_connection_tunnels.this.ip_sec_connection_tunnels
}

output "ipsec_connection_tunnel" {
  description = "Selected IPSec tunnel data source response."
  value       = data.oci_core_ipsec_connection_tunnel.this
  sensitive   = true
}

output "ipsec_connection_tunnel_routes" {
  description = "Selected IPSec tunnel routes data source response."
  value       = data.oci_core_ipsec_connection_tunnel_routes.this.tunnel_routes
}
