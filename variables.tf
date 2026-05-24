variable "tenancy_ocid" {
  description = "Tenancy OCID used by the OCI provider."
  type        = string
}

variable "region" {
  description = "OCI region where the reproducer will run."
  type        = string
}

variable "compartment_ids" {
  description = "Map of friendly compartment names to compartment OCIDs."
  type        = map(string)
}

variable "cpes" {
  description = "Customer premises equipment definitions keyed by logical name."
  type = map(object({
    compartment_name    = string
    display_name        = string
    ip_address          = string
    is_private          = optional(bool, true)
    cpe_device_shape_id = optional(string)
    defined_tags        = optional(map(string))
    freeform_tags       = optional(map(string), {})
  }))
}

variable "drgs" {
  description = "DRG definitions keyed by logical name."
  type = map(object({
    compartment_name = string
    display_name     = string
    defined_tags     = optional(map(string))
    freeform_tags    = optional(map(string), {})
  }))
}

variable "ipsecs" {
  description = "IPSec connection definitions keyed by logical name."
  type = map(object({
    compartment_name          = string
    display_name              = string
    cpe_name                  = string
    drg_name                  = string
    static_routes             = optional(list(string), [])
    cpe_local_identifier      = optional(string)
    cpe_local_identifier_type = optional(string)
    defined_tags              = optional(map(string))
    freeform_tags             = optional(map(string), {})
    tunnel_configuration = optional(list(object({
      associated_virtual_circuits = optional(list(string), [])
      drg_route_table_id          = optional(string)
      oracle_tunnel_ip            = optional(string)
    })), [])
  }))

  validation {
    condition = alltrue([
      for ipsec in values(var.ipsecs) :
      ipsec.cpe_local_identifier_type == null || contains(["HOSTNAME", "IP_ADDRESS"], ipsec.cpe_local_identifier_type)
    ])
    error_message = "cpe_local_identifier_type must be HOSTNAME or IP_ADDRESS when set."
  }

  validation {
    condition = alltrue([
      for ipsec in values(var.ipsecs) :
      length(ipsec.tunnel_configuration) <= 2
    ])
    error_message = "Each ipsec.tunnel_configuration list can contain at most 2 entries."
  }
}
