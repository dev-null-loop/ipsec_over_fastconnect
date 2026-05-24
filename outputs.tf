output "cpes" {
  description = "Created CPEs keyed by logical name."
  value = {
    for name, cpe in oci_core_cpe.this : name => {
      id         = cpe.id
      ip_address = cpe.ip_address
      is_private = cpe.is_private
    }
  }
}

output "drgs" {
  description = "Created DRGs keyed by logical name."
  value = {
    for name, drg in oci_core_drg.this : name => {
      id           = drg.id
      display_name = drg.display_name
      state        = drg.state
    }
  }
}

output "ipsecs" {
  description = "Created IPSec connections keyed by logical name."
  value = {
    for name, ipsec in oci_core_ipsec.this : name => {
      display_name   = ipsec.display_name
      id             = ipsec.id
      transport_type = ipsec.transport_type
    }
  }
}
