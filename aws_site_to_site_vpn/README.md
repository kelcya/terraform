# AWS Site to Site VPN (IPsec) module

## Description

AWS site to site IPsec tunnel used to connect to customer network.


## Example

```
vpn_connections = {
    connection1 = { vpn_client_cidr_block = "10.2.15.62/32", vpn_local_cidr_block  = "10.12.4.0/18", vpn_client_gateway = "125.22.21.4" }
  }

module "vpn_gateway" {
  count = var.enable_vpn ? 1 : 0
  source = "../../modules/aws_site_to_site_vpn"
  client_name     = "client_name"
  vpc_name        = "vpc_name"
  vpn_connections = var.vpn_connections
}
```


## Changelog
* 1.1.0 - Added multiple connection support
* 1.0.0 - Initial module