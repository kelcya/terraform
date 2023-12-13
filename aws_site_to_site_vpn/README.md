# AWS Site to Site VPN (IPsec)

## Description

AWS site to site IPsec tunnel used to connect to customer network. Currently used for EMR data syncs.

```
enable_vpn            = true
vpn_client_cidr_block = "10.0.18.66/32"
vpn_local_cidr_block  = "10.32.192.104/32"
vpn_client_gateway    = "54.87.245.72"
```

## Source

```
s3::https://s3.amazonaws.com/cedar-terraform-modules/aws_site_to_site_vpn-v1.0.0.tgz
```

## Changelog
* 1.0.0 - Initial module