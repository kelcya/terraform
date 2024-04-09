variable "vpc_name" {
  type        = string
  description = "VPC name. You must supply this and it should be globally unique"
}

variable "client_name" {
  type        = string
  description = "Client customer name"
}

variable "tags" {
  type        = map(any)
  description = "Tags that should be attached to all resources in this module"
  default     = {}
}

variable "customer_gateway_bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
  type        = number
  default     = 65000
}

variable "customer_gateway_ip_address" {
  description = "Specify the internet-routable IP address for your gateway's external interface; the address must be static and may be behind a device performing network address translation (NAT)."
  type        = string
  default     = null
}

variable "customer_gateway_device_name" {
  description = "(Optional) Enter a name for the customer gateway device."
  type        = string
  default     = null
}

variable "route_propagation_route_table_ids" {
  description = "(Optional)The IDs of the route tables for which routes from the Virtual Private Gateway will be propagated"
  type        = list(string)
  default     = []
}

variable "vpn_connection_static_routes_only" {
  description = "(Optional, Default false) Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP."
  type        = bool
  default     = true
}

# aws naming is a little confusing
# local cidr is remote, destination cidr (customer)
variable "vpn_connection_local_ipv4_network_cidr" {
  description = "(Optional, Default 0.0.0.0/0) The IPv4 CIDR on the customer gateway (on-premises) side of the VPN connection."
  type        = string
  default     = null
}

# remote cidr is local network cidr
variable "vpn_connection_remote_ipv4_network_cidr" {
  description = "(Optional, Default 0.0.0.0/0) The IPv4 CIDR on the AWS side of the VPN connection."
  type        = string
  default     = null
}

variable "vpn_connection_tunnel1_inside_cidr" {
  description = "(Optional) The CIDR block of the inside IP addresses for the first VPN tunnel. Valid value is a size /30 CIDR block from the 169.254.0.0/16 range."
  type        = string
  default     = null
}
variable "vpn_connection_tunnel2_inside_cidr" {
  description = "(Optional) The CIDR block of the inside IP addresses for the second VPN tunnel. Valid value is a size /30 CIDR block from the 169.254.0.0/16 range."
  type        = string
  default     = null
}

variable "vpn_connection_tunnel1_preshared_key" {
  description = "(Optional) The preshared key of the first VPN tunnel. The preshared key must be between 8 and 64 characters in length and cannot start with zero(0). Allowed characters are alphanumeric characters, periods(.) and underscores(_)."
  type        = string
  default     = null
  sensitive   = true
}

variable "vpn_connection_tunnel2_preshared_key" {
  description = "(Optional) The preshared key of the second VPN tunnel. The preshared key must be between 8 and 64 characters in length and cannot start with zero(0). Allowed characters are alphanumeric characters, periods(.) and underscores(_)."
  type        = string
  default     = null
  sensitive   = true
}

variable "vpn_connection_tunnel1_ike_versions" {
  description = "(Optional) The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 | ikev2."
  type        = set(string)
  default     = ["ikev2"]
}

variable "vpn_connection_tunnel2_ike_versions" {
  description = "(Optional) The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 | ikev2."
  type        = set(string)
  default     = ["ikev2"]
}

variable "vpn_connection_tunnel1_dpd_timeout_action" {
  description = "(Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. Specify restart to restart the IKE initiation. Specify clear to end the IKE session. Valid values are clear | none | restart."
  type        = string
  default     = "restart"
  validation {
    condition     = can(regex("^(clear|none|restart)$", var.vpn_connection_tunnel1_dpd_timeout_action))
    error_message = "Invalid input, options: \"clear\", \"none\", \"restart\"."
  }
}

variable "vpn_connection_tunnel2_dpd_timeout_action" {
  description = "(Optional, Default clear) The action to take after DPD timeout occurs for the second VPN tunnel. Specify restart to restart the IKE initiation. Specify clear to end the IKE session. Valid values are clear | none | restart."
  type        = string
  default     = "restart"
  validation {
    condition     = can(regex("^(clear|none|restart)$", var.vpn_connection_tunnel2_dpd_timeout_action))
    error_message = "Invalid input, options: \"clear\", \"none\", \"restart\"."
  }
}

variable "vpn_connection_tunnel1_dpd_timeout_seconds" {
  description = "(Optional, Default 40) The number of seconds after which a DPD timeout occurs for the second VPN tunnel. Valid value is equal or higher than 30."
  type        = number
  default     = 40
}

variable "vpn_connection_tunnel2_dpd_timeout_seconds" {
  description = "(Optional, Default 40) The number of seconds after which a DPD timeout occurs for the second VPN tunnel. Valid value is equal or higher than 30."
  type        = string
  default     = 40
}

variable "vpn_connection_tunnel1_phase1_dh_group_numbers" {
  description = "(Optional) List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24."
  type        = list(number)
  default     = [14, 15, 16, 17, 18, 19, 20, 21]
}

variable "vpn_connection_tunnel2_phase1_dh_group_numbers" {
  description = "(Optional) List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24."
  type        = list(number)
  default     = [14, 15, 16, 17, 18, 19, 20, 21]
}

variable "vpn_connection_tunnel1_phase1_encryption_algorithms" {
  description = "(Optional) List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16."
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "vpn_connection_tunnel2_phase1_encryption_algorithms" {
  description = "(Optional) List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16."
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "vpn_connection_tunnel1_phase1_integrity_algorithms" {
  description = "(Optional) One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512."
  type        = list(string)
  default     = ["SHA2-256", "SHA2-384", "SHA2-512"]

}

variable "vpn_connection_tunnel2_phase1_integrity_algorithms" {
  description = "(Optional) One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512."
  type        = list(string)
  default     = ["SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "vpn_connection_tunnel1_phase1_lifetime_seconds" {
  description = "(Optional, Default 28800) The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 28800."
  type        = number
  default     = 28800
}

variable "vpn_connection_tunnel2_phase1_lifetime_seconds" {
  description = "(Optional, Default 28800) The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. Valid value is between 900 and 28800."
  type        = number
  default     = 28800
}

variable "vpn_connection_tunnel2_phase2_dh_group_numbers" {
  description = "(Optional) List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 2 IKE negotiations. Valid values are 2 | 5 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24."
  type        = list(number)
  default     = [14, 15, 16, 17, 18, 19, 20, 21]
}

variable "vpn_connection_tunnel1_phase2_dh_group_numbers" {
  description = "(Optional) List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are 2 | 5 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24."
  type        = list(number)
  default     = [14, 15, 16, 17, 18, 19, 20, 21]
}

variable "vpn_connection_tunnel1_phase2_encryption_algorithms" {
  description = "(Optional) List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16."
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "vpn_connection_tunnel2_phase2_encryption_algorithms" {
  description = "(Optional) List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16."
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "vpn_connection_tunnel1_phase2_integrity_algorithms" {
  description = "(Optional) List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512."
  type        = list(string)
  default     = ["SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "vpn_connection_tunnel2_phase2_integrity_algorithms" {
  description = "(Optional) List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512."
  type        = list(string)
  default     = ["SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "vpn_connection_tunnel1_phase2_lifetime_seconds" {
  description = "(Optional, Default 3600) The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 3600."
  type        = number
  default     = 3600
}

variable "vpn_connection_tunnel2_phase2_lifetime_seconds" {
  description = "(Optional, Default 3600) The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. Valid value is between 900 and 3600."
  type        = number
  default     = 3600
}

variable "vpn_connection_tunnel1_startup_action" {
  description = "(Optional, Default add) The action to take when the establishing the tunnel for the first VPN connection. By default, your customer gateway device must initiate the IKE negotiation and bring up the tunnel. Specify start for AWS to initiate the IKE negotiation. Valid values are add | start."
  type        = string
  default     = "add"
}

variable "vpn_connection_tunnel2_startup_action" {
  description = "(Optional, Default add) The action to take when the establishing the tunnel for the second VPN connection. By default, your customer gateway device must initiate the IKE negotiation and bring up the tunnel. Specify start for AWS to initiate the IKE negotiation. Valid values are add | start."
  type        = string
  default     = "add"
}

variable "vpn_connection_tunnel_inside_ip_version" {
  description = "(Optional, Default ipv4) Indicate whether the VPN tunnels process IPv4 or IPv6 traffic. Valid values are ipv4 | ipv6. ipv6 Supports only EC2 Transit Gateway."
  type        = string
  default     = "ipv4"
  validation {
    condition     = can(regex("^(ipv4|ipv6)$", var.vpn_connection_tunnel_inside_ip_version))
    error_message = "Invalid input, options: \"ipv4\", \"ipv6\"."
  }
}

variable "vpn_connections" {
  description = "VPN connection information"
  type = map(any)
}