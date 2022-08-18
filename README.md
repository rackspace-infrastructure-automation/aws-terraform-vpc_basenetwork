# aws-terraform-vpc\_basenetwork

This module sets up basic network components for an account in a specific region. Optionally it will setup a basic VPN gateway and VPC flow logs.

## Basic Usage

```HCL
module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.12.2"

  vpc_name = "MyVPC"
}
```

 Full working references are available at [examples](examples)
## Default Resources

By default only `vpc_name` is required to be set. Unless changed `aws_region` defaults to `us-west-2` and will need to be updated for other regions. `source` will also need to be declared depending on where the module lives. Given default settings the following resources are created:

 - VPC Flow Logs
 - 2 AZs with public/private subnets from the list of 3 static CIDRs ranges available for each as defaults
 - Public/private subnets with the count related to custom\_azs if defined or region AZs automatically calculated by Terraform otherwise
 - NAT Gateways will be created in each AZ's first public subnet
 - EIPs will be created in all public subnets for NAT gateways to use
 - Route Tables, including routes to NAT gateways if applicable

## Terraform 0.12 upgrade

Several changes were required while adding terraform 0.12 compatibility.  The following changes should be
made when upgrading from a previous release to version 0.12.0 or higher.

### Module variables

The following module variables were updated to better meet current Rackspace style guides:

- `custom_tags` -> `tags`
- `vpc_name` -> `name`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flowlog_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.cw_vpc_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_flow_log.s3_vpc_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.flowlog_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flowlog_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_route_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.vpc_log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.private_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpn_gateway.vpn_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_vpn_gateway_route_propagation.vpn_routes_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_vpn_gateway_route_propagation.vpn_routes_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of AZs to utilize for the subnets | `number` | `2` | no |
| <a name="input_build_flow_logs"></a> [build\_flow\_logs](#input\_build\_flow\_logs) | Whether or not to build flow log components in Cloudwatch Logs | `bool` | `false` | no |
| <a name="input_build_igw"></a> [build\_igw](#input\_build\_igw) | Whether or not to build an internet gateway.  If disabled, no public subnets or route tables, internet gateway, or NAT Gateways will be created. | `bool` | `true` | no |
| <a name="input_build_nat_gateways"></a> [build\_nat\_gateways](#input\_build\_nat\_gateways) | Whether or not to build a NAT gateway per AZ.  if `build_igw` is set to false, this value is ignored. | `bool` | `true` | no |
| <a name="input_build_s3_flow_logs"></a> [build\_s3\_flow\_logs](#input\_build\_s3\_flow\_logs) | Whether or not to build flow log components in s3 | `bool` | `false` | no |
| <a name="input_build_vpn"></a> [build\_vpn](#input\_build\_vpn) | Whether or not to build a VPN gateway | `bool` | `false` | no |
| <a name="input_cidr_range"></a> [cidr\_range](#input\_cidr\_range) | CIDR range for the VPC | `string` | `"172.18.0.0/19"` | no |
| <a name="input_cloudwatch_flowlog_retention"></a> [cloudwatch\_flowlog\_retention](#input\_cloudwatch\_flowlog\_retention) | The number of days to retain flowlogs in CLoudwatch Logs. Valid values are: [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]. A value of `0` will retain indefinitely. | `number` | `14` | no |
| <a name="input_custom_azs"></a> [custom\_azs](#input\_custom\_azs) | A list of AZs that VPC resources will reside in | `list(string)` | `[]` | no |
| <a name="input_default_tenancy"></a> [default\_tenancy](#input\_default\_tenancy) | Default tenancy for instances. Either multi-tenant (default) or single-tenant (dedicated) | `string` | `"default"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Custom domain name for the VPC | `string` | `""` | no |
| <a name="input_domain_name_servers"></a> [domain\_name\_servers](#input\_domain\_name\_servers) | Array of custom domain name servers | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether or not to enable DNS hostnames for the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether or not to enable DNS support for the VPC | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment for which this network is being created. e.g. Development/Production | `string` | `"Development"` | no |
| <a name="input_logging_bucket_access_control"></a> [logging\_bucket\_access\_control](#input\_logging\_bucket\_access\_control) | Define ACL for Bucket from one of the [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl): private, public-read, public-read-write, aws-exec-read, authenticated-read, log-delivery-write | `string` | `"private"` | no |
| <a name="input_logging_bucket_encryption"></a> [logging\_bucket\_encryption](#input\_logging\_bucket\_encryption) | Enable default bucket encryption. i.e. AES256 or aws:kms | `string` | `"AES256"` | no |
| <a name="input_logging_bucket_encryption_kms_mster_key"></a> [logging\_bucket\_encryption\_kms\_mster\_key](#input\_logging\_bucket\_encryption\_kms\_mster\_key) | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. | `string` | `""` | no |
| <a name="input_logging_bucket_force_destroy"></a> [logging\_bucket\_force\_destroy](#input\_logging\_bucket\_force\_destroy) | Whether all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. ie. true | `bool` | `false` | no |
| <a name="input_logging_bucket_name"></a> [logging\_bucket\_name](#input\_logging\_bucket\_name) | Bucket name to store s3 flow logs. If empty, a random bucket name is generated. Use in conjuction with `build_s3_flow_logs` | `string` | `""` | no |
| <a name="input_logging_bucket_prefix"></a> [logging\_bucket\_prefix](#input\_logging\_bucket\_prefix) | The prefix for the location in the S3 bucket. If you don't specify a prefix, the access logs are stored in the root of the bucket. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for the VPC and related resources | `string` | n/a | yes |
| <a name="input_private_cidr_ranges"></a> [private\_cidr\_ranges](#input\_private\_cidr\_ranges) | An array of CIDR ranges to use for private subnets | `list(string)` | <pre>[<br>  "172.18.16.0/22",<br>  "172.18.20.0/22",<br>  "172.18.24.0/22"<br>]</pre> | no |
| <a name="input_private_subnet_names"></a> [private\_subnet\_names](#input\_private\_subnet\_names) | Text that will be included in generated name for private subnets. Given the default value of `["Private"]`, subnet<br>names in the form \"<vpc\_name>-Private<count+1>\", e.g. \"MyVpc-Public2\" will be produced. Otherwise, given a<br>list of names with length the same as the value of `az_count`, the first `az_count` subnets will be named using<br>the first string in the list, the second `az_count` subnets will be named using the second string, and so on. | `list(string)` | <pre>[<br>  "Private"<br>]</pre> | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | A list of maps containing tags to be applied to private subnets. List should either be the same length as the number of AZs to apply different tags per set of subnets, or a length of 1 to apply the same tags across all private subnets. | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_private_subnets_per_az"></a> [private\_subnets\_per\_az](#input\_private\_subnets\_per\_az) | Number of private subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`,<br>should not exceed the length of the `private_cidr_ranges` list! | `number` | `1` | no |
| <a name="input_public_cidr_ranges"></a> [public\_cidr\_ranges](#input\_public\_cidr\_ranges) | An array of CIDR ranges to use for public subnets | `list(string)` | <pre>[<br>  "172.18.0.0/22",<br>  "172.18.4.0/22",<br>  "172.18.8.0/22"<br>]</pre> | no |
| <a name="input_public_subnet_names"></a> [public\_subnet\_names](#input\_public\_subnet\_names) | Text that will be included in generated name for public subnets. Given the default value of `["Public"]`, subnet<br>names in the form \"<vpc\_name>-Public<count+1>\", e.g. \"MyVpc-Public1\" will be produced. Otherwise, given a<br>list of names with length the same as the value of `az_count`, the first `az_count` subnets will be named using<br>the first string in the list, the second `az_count` subnets will be named using the second string, and so on. | `list(string)` | <pre>[<br>  "Public"<br>]</pre> | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | A list of maps containing tags to be applied to public subnets. List should either be the same length as the number of AZs to apply different tags per set of subnets, or a length of 1 to apply the same tags across all public subnets. | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_public_subnets_per_az"></a> [public\_subnets\_per\_az](#input\_public\_subnets\_per\_az) | Number of public subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`,<br>should not exceed the length of the `public_cidr_ranges` list! | `number` | `1` | no |
| <a name="input_s3_flowlog_retention"></a> [s3\_flowlog\_retention](#input\_s3\_flowlog\_retention) | The number of days to retain flowlogs in s3. A value of `0` will retain indefinitely. | `number` | `14` | no |
| <a name="input_single_nat"></a> [single\_nat](#input\_single\_nat) | Deploy VPC in single NAT mode. | `bool` | `false` | no |
| <a name="input_spoke_vpc"></a> [spoke\_vpc](#input\_spoke\_vpc) | Whether or not the VPN gateway is a spoke of a Transit VPC | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional tags to be applied on top of the base tags on all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_sg"></a> [default\_sg](#output\_default\_sg) | The ID of the default SG for the VPC |
| <a name="output_flowlog_log_group_arn"></a> [flowlog\_log\_group\_arn](#output\_flowlog\_log\_group\_arn) | The ARN of the flow log CloudWatch log group if one was created |
| <a name="output_flowlog_log_group_name"></a> [flowlog\_log\_group\_name](#output\_flowlog\_log\_group\_name) | The name of the flow log CloudWatch log group if one was created |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | The ID of the Internet Gateway |
| <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway) | The ID of the NAT Gateway if one was created |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | The ID of the NAT Gateway if one was created |
| <a name="output_nat_gateway_private_ips"></a> [nat\_gateway\_private\_ips](#output\_nat\_gateway\_private\_ips) | The private IPs of the NAT Gateway if one was created |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | The public IPs of the NAT Gateway if one was created |
| <a name="output_private_route_tables"></a> [private\_route\_tables](#output\_private\_route\_tables) | The IDs for the private route tables |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | The IDs for the private subnets |
| <a name="output_public_route_tables"></a> [public\_route\_tables](#output\_public\_route\_tables) | The IDs for the public route tables |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | The IDs of the public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpn_gateway"></a> [vpn\_gateway](#output\_vpn\_gateway) | The ID of the VPN gateway if one was created |
