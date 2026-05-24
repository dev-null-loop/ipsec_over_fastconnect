variable "tenancy_ocid" {
  description = "Tenancy OCID used by the OCI provider."
  type        = string
}

variable "region" {
  description = "OCI region where the example will run."
  type        = string
}

variable "compartment_ids" {
  description = "Map of friendly compartment names to compartment OCIDs."
  type        = map(string)
}

variable "compartment_name" {
  description = "Friendly compartment name used to resolve the target compartment from compartment_ids."
  type        = string
}

variable "cpe_device_shape_id" {
  description = "Optional explicit CPE device shape OCID. If null, the first shape returned by OCI is used."
  type        = string
  default     = null
}

variable "cross_connect_location_name" {
  description = "Optional explicit FastConnect location name. If null, the first location returned by OCI is used."
  type        = string
  default     = null
}

variable "cross_connect_port_speed_shape_name" {
  description = "Optional explicit FastConnect port speed shape name. If null, the first shape returned by OCI is used."
  type        = string
  default     = null
}

variable "ipsec_connection_tunnel_route_advertiser" {
  description = "Advertiser used by the IPSec tunnel routes data source."
  type        = string
  default     = "CUSTOMER"
}

variable "cpe" {
  description = "CPE configuration."
  type = object({
    display_name  = string
    ip_address    = string
    is_private    = optional(bool, true)
    defined_tags  = optional(map(string))
    freeform_tags = optional(map(string), {})
  })
}

variable "drg" {
  description = "DRG configuration."
  type = object({
    display_name  = string
    defined_tags  = optional(map(string))
    freeform_tags = optional(map(string), {})
  })
}

variable "drg_route_table" {
  description = "DRG route table configuration."
  type = object({
    display_name = string
  })
}

variable "cross_connect" {
  description = "Cross-connect configuration."
  type = object({
    display_name                                 = string
    is_active                                    = optional(bool, true)
    cross_connect_group_id                       = optional(string)
    customer_reference_name                      = optional(string)
    far_cross_connect_or_cross_connect_group_id  = optional(string)
    near_cross_connect_or_cross_connect_group_id = optional(string)
    defined_tags                                 = optional(map(string))
    freeform_tags                                = optional(map(string), {})
  })
}

variable "virtual_circuit" {
  description = "Virtual circuit configuration."
  type = object({
    type                 = string
    bandwidth_shape_name = string
    customer_asn         = string
    display_name         = string
    cross_connect_mapping = object({
      bgp_md5auth_key           = optional(string)
      customer_bgp_peering_ip   = string
      customer_bgp_peering_ipv6 = optional(string)
      oracle_bgp_peering_ip     = string
      oracle_bgp_peering_ipv6   = optional(string)
      vlan                      = number
    })
  })
}

variable "ipsec" {
  description = "Private IPSec connection configuration."
  type = object({
    static_routes             = list(string)
    cpe_local_identifier      = string
    cpe_local_identifier_type = string
    display_name              = string
    defined_tags              = optional(map(string))
    freeform_tags             = optional(map(string), {})
    tunnel_configuration = list(object({
      oracle_tunnel_ip = string
    }))
  })

  validation {
    condition     = contains(["HOSTNAME", "IP_ADDRESS"], var.ipsec.cpe_local_identifier_type)
    error_message = "ipsec.cpe_local_identifier_type must be HOSTNAME or IP_ADDRESS."
  }

  validation {
    condition     = length(var.ipsec.tunnel_configuration) == 2
    error_message = "ipsec.tunnel_configuration must contain exactly 2 entries for this private IPSec over FastConnect example."
  }
}

variable "first_tunnel_management" {
  description = "Configuration for the first IPSec tunnel management resource."
  type = object({
    display_name  = string
    routing       = string
    shared_secret = string
    ike_version   = string
    bgp_session_info = object({
      customer_bgp_asn        = string
      customer_interface_ip   = string
      oracle_interface_ip     = string
      customer_interface_ipv6 = string
      oracle_interface_ipv6   = string
    })
  })
}

variable "second_tunnel_management" {
  description = "Configuration for the second IPSec tunnel management resource."
  type = object({
    display_name            = string
    routing                 = string
    shared_secret           = string
    ike_version             = string
    nat_translation_enabled = string
    oracle_can_initiate     = string
    encryption_domain_config = object({
      cpe_traffic_selector    = list(string)
      oracle_traffic_selector = list(string)
    })
    phase_one_details = object({
      is_custom_phase_one_config = bool
      lifetime                   = number
    })
    phase_two_details = object({
      dh_group                   = string
      is_custom_phase_two_config = bool
      is_pfs_enabled             = bool
      lifetime                   = number
    })
  })
}
