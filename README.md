# Base Network

## Description

This module sets up basic network components for an account in a specific region. Optionally it will setup a basic VPN gateway and VPC flow logs.

## Default Resources

By default only `vpc_name` is required to be set. Unless changed `aws_region` defaults to `us-west-2` and will need to be updated for other regions. `source` will also need to be declared depending on where the module lives. Given default settings the following resources are created:

* VPC Flow Logs
* 2 public/private subnets static CIDRs ranges are setup to be used for default cases
* Public/private subnets with the count related to custom_azs if defined or region AZs automatically calculated by Terraform otherwise
* NAT Gateways will be created in all public subnets
* EIPs will be created in all public subnets for NAT gateways to use
* Route Tables, including routes to NAT gateways if applicable

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| az_count | Number of AZs to utilize for the subnets | string | `2` | no |
| build_flow_logs | Whether or not to build flow log components | string | `false` | no |
| build_nat_gateways | Whether or not to build a NAT gateway per AZ | string | `true` | no |
| build_vpn | Whether or not to build a VPN gateway | string | `false` | no |
| cidr_range | CIDR range for the VPC | string | `172.18.0.0/16` | no |
| custom_azs | A list of AZs that VPC resources will reside in | list | `<list>` | no |
| custom_tags | Optional tags to be applied on top of the base tags on all resources | map | `<map>` | no |
| default_tenancy | Default tenancy for instances. Either multi-tenant (default) or single-tenant (dedicated) | string | `default` | no |
| domain_name | Custom domain name for the VPC | string | `` | no |
| domain_name_servers | Array of custom domain name servers | list | `<list>` | no |
| enable_dns_hostnames | Whether or not to enable DNS hostnames for the VPC | string | `true` | no |
| enable_dns_support | Whether or not to enable DNS support for the VPC | string | `true` | no |
| environment | Application environment for which this network is being created. e.g. Development/Production | string | `Development` | no |
| private_cidr_ranges | An array of CIDR ranges to use for private subnets | list | `<list>` | no |
| private_subnets_per_az | Number of private subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`, should not exceed the length of the `private_cidr_ranges` list! | string | `1` | no |
| public_cidr_ranges | An array of CIDR ranges to use for public subnets | list | `<list>` | no |
| public_subnets_per_az | Number of public subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`, should not exceed the length of the `public_cidr_ranges` list! | string | `1` | no |
| spoke_vpc | Whether or not the VPN gateway is a spoke of a Transit VPC | string | `false` | no |
| vpc_name | Name for the VPC | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| default_sg | The ID of the default SG for the VPC |
| flowlog_log_group_arn | The ARN of the flow log CloudWatch log group if one was created |
| private_route_tables | The IDs for the private route tables |
| private_subnets | The IDs for the private subnets |
| public_route_tables | The IDs for the public route tables |
| public_subnets | The IDs of the public subnets |
| vpc_id | The ID of the VPC |
| vpn_gateway | The ID of the VPN gateway if one was created |

### Examples

The `examples` folder contains examples of general usage for easy copy and paste.
