locals {
  common_tags = merge(var.tags, {
    Customer        = var.client_name
    TerraformModule = "aws_site_to_site_vpn",
  })
}

# There is a weird bug in terraform (1.5.7) with the aws_vpn_connection aws resource (aws provider 5.43), where multiple aws vpn connections cannot use the same customer gateway. If multiple connections are created with reference to the same customer gateway, the vpn connections will override each other. Terraform state will show multiple vpn connections but on the AWS console, there is only 1 connection because the vpn connection id is the same for both connections due to the same customer gateway used.
# As a work around, a customer gateway is created for each vpn connection.
resource "aws_customer_gateway" "main" {
  for_each = var.vpn_connections
  bgp_asn     = var.customer_gateway_bgp_asn
  ip_address  = each.value.vpn_client_gateway
  type        = "ipsec.1"
  device_name = "${var.client_name}_${each.key}"
  tags = merge(local.common_tags, {
    Name = "${var.client_name}_${each.key}"
  })
}

data "aws_vpn_gateway" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-vgw"]
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.client_name}-vpn_gateway"
  retention_in_days = "7"
}

resource "aws_vpn_connection" "main" {
  for_each = var.vpn_connections
  customer_gateway_id = aws_customer_gateway.main[each.key].id
  vpn_gateway_id      = data.aws_vpn_gateway.selected.id
  type                = "ipsec.1"

  # aws is confusing. local network cidr is the customer/client side while remote network cidr is the cedar aws network/resources.
  static_routes_only       = var.vpn_connection_static_routes_only
  local_ipv4_network_cidr  = each.value.vpn_client_cidr_block
  remote_ipv4_network_cidr = each.value.vpn_local_cidr_block

  #vpn_connection_tunnel
  tunnel_inside_ip_version = var.vpn_connection_tunnel_inside_ip_version
  tunnel1_preshared_key                = var.vpn_connection_tunnel1_preshared_key
  tunnel1_dpd_timeout_action           = var.vpn_connection_tunnel1_dpd_timeout_action
  tunnel1_dpd_timeout_seconds          = var.vpn_connection_tunnel1_dpd_timeout_seconds
  tunnel1_ike_versions                 = var.vpn_connection_tunnel1_ike_versions
  tunnel1_phase1_dh_group_numbers      = var.vpn_connection_tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = var.vpn_connection_tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.vpn_connection_tunnel1_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = var.vpn_connection_tunnel1_phase1_lifetime_seconds
  tunnel1_phase2_dh_group_numbers      = var.vpn_connection_tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.vpn_connection_tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.vpn_connection_tunnel1_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = var.vpn_connection_tunnel1_phase2_lifetime_seconds
  tunnel1_startup_action               = var.vpn_connection_tunnel1_startup_action
  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.main.arn
      log_output_format = "json"
    }
  }

  tunnel2_preshared_key                = var.vpn_connection_tunnel2_preshared_key
  tunnel2_dpd_timeout_action           = var.vpn_connection_tunnel2_dpd_timeout_action
  tunnel2_dpd_timeout_seconds          = var.vpn_connection_tunnel2_dpd_timeout_seconds
  tunnel2_ike_versions                 = var.vpn_connection_tunnel2_ike_versions
  tunnel2_phase1_dh_group_numbers      = var.vpn_connection_tunnel2_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms = var.vpn_connection_tunnel2_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.vpn_connection_tunnel2_phase1_integrity_algorithms
  tunnel2_phase1_lifetime_seconds      = var.vpn_connection_tunnel2_phase1_lifetime_seconds
  tunnel2_phase2_dh_group_numbers      = var.vpn_connection_tunnel2_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = var.vpn_connection_tunnel2_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = var.vpn_connection_tunnel2_phase2_integrity_algorithms
  tunnel2_phase2_lifetime_seconds      = var.vpn_connection_tunnel2_phase2_lifetime_seconds
  tunnel2_startup_action               = var.vpn_connection_tunnel2_startup_action
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_group_arn     = aws_cloudwatch_log_group.main.arn
      log_output_format = "json"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.client_name}_${each.key}"
  })
}

resource "aws_vpn_connection_route" "main" {
  for_each = var.vpn_connections
  destination_cidr_block = each.value.vpn_client_cidr_block
  vpn_connection_id      = aws_vpn_connection.main[each.key].id
}