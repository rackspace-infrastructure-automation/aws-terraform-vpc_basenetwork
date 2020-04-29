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

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| az\_count | Number of AZs to utilize for the subnets | `number` | `2` | no |
| build\_flow\_logs | Whether or not to build flow log components in Cloudwatch Logs | `bool` | `false` | no |
| build\_igw | Whether or not to build an internet gateway.  If disabled, no public subnets or route tables, internet gateway, or NAT Gateways will be created. | `bool` | `true` | no |
| build\_nat\_gateways | Whether or not to build a NAT gateway per AZ.  if `build_igw` is set to false, this value is ignored. | `bool` | `true` | no |
| build\_s3\_flow\_logs | Whether or not to build flow log components in s3 | `bool` | `false` | no |
| build\_vpn | Whether or not to build a VPN gateway | `bool` | `false` | no |
| cidr\_range | CIDR range for the VPC | `string` | `"172.18.0.0/19"` | no |
| cloudwatch\_flowlog\_retention | The number of days to retain flowlogs in CLoudwatch Logs. Valid values are: [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]. A value of `0` will retain indefinitely. | `number` | `14` | no |
| custom\_azs | A list of AZs that VPC resources will reside in | `list(string)` | `[]` | no |
| default\_tenancy | Default tenancy for instances. Either multi-tenant (default) or single-tenant (dedicated) | `string` | `"default"` | no |
| domain\_name | Custom domain name for the VPC | `string` | `""` | no |
| domain\_name\_servers | Array of custom domain name servers | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| enable\_dns\_hostnames | Whether or not to enable DNS hostnames for the VPC | `bool` | `true` | no |
| enable\_dns\_support | Whether or not to enable DNS support for the VPC | `bool` | `true` | no |
| environment | Application environment for which this network is being created. e.g. Development/Production | `string` | `"Development"` | no |
| logging\_bucket\_access\_control | Define ACL for Bucket from one of the [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl): private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, bucket-owner-full-control, log-delivery-write | `string` | `"bucket-owner-full-control"` | no |
| logging\_bucket\_encryption | Enable default bucket encryption. i.e. AES256 or aws:kms | `string` | `"AES256"` | no |
| logging\_bucket\_encryption\_kms\_mster\_key | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. | `string` | `""` | no |
| logging\_bucket\_force\_destroy | Whether all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. ie. true | `bool` | `false` | no |
| logging\_bucket\_name | Bucket name to store s3 flow logs. If empty, a random bucket name is generated. Use in conjuction with `build_s3_flow_logs` | `string` | `""` | no |
| logging\_bucket\_prefix | The prefix for the location in the S3 bucket. If you don't specify a prefix, the access logs are stored in the root of the bucket. | `string` | `""` | no |
| name | Name prefix for the VPC and related resources | `string` | n/a | yes |
| private\_cidr\_ranges | An array of CIDR ranges to use for private subnets | `list(string)` | <pre>[<br>  "172.18.16.0/22",<br>  "172.18.20.0/22",<br>  "172.18.24.0/22"<br>]</pre> | no |
| private\_subnet\_names | Text that will be included in generated name for private subnets. Given the default value of `["Private"]`, subnet<br>names in the form \"<vpc\_name>-Private<count+1>\", e.g. \"MyVpc-Public2\" will be produced. Otherwise, given a<br>list of names with length the same as the value of `az_count`, the first `az_count` subnets will be named using<br>the first string in the list, the second `az_count` subnets will be named using the second string, and so on. | `list(string)` | <pre>[<br>  "Private"<br>]</pre> | no |
| private\_subnet\_tags | A list of maps containing tags to be applied to private subnets. List should either be the same length as the number of AZs to apply different tags per set of subnets, or a length of 1 to apply the same tags across all private subnets. | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| private\_subnets\_per\_az | Number of private subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`,<br>should not exceed the length of the `private_cidr_ranges` list! | `number` | `1` | no |
| public\_cidr\_ranges | An array of CIDR ranges to use for public subnets | `list(string)` | <pre>[<br>  "172.18.0.0/22",<br>  "172.18.4.0/22",<br>  "172.18.8.0/22"<br>]</pre> | no |
| public\_subnet\_names | Text that will be included in generated name for public subnets. Given the default value of `["Public"]`, subnet<br>names in the form \"<vpc\_name>-Public<count+1>\", e.g. \"MyVpc-Public1\" will be produced. Otherwise, given a<br>list of names with length the same as the value of `az_count`, the first `az_count` subnets will be named using<br>the first string in the list, the second `az_count` subnets will be named using the second string, and so on. | `list(string)` | <pre>[<br>  "Public"<br>]</pre> | no |
| public\_subnet\_tags | A list of maps containing tags to be applied to public subnets. List should either be the same length as the number of AZs to apply different tags per set of subnets, or a length of 1 to apply the same tags across all public subnets. | `list(map(string))` | <pre>[<br>  {}<br>]</pre> | no |
| public\_subnets\_per\_az | Number of public subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`,<br>should not exceed the length of the `public_cidr_ranges` list! | `number` | `1` | no |
| s3\_flowlog\_retention | The number of days to retain flowlogs in s3. A value of `0` will retain indefinitely. | `number` | `14` | no |
| single\_nat | Deploy VPC in single NAT mode. | `bool` | `false` | no |
| spoke\_vpc | Whether or not the VPN gateway is a spoke of a Transit VPC | `bool` | `false` | no |
| tags | Optional tags to be applied on top of the base tags on all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_sg | The ID of the default SG for the VPC |
| flowlog\_log\_group\_arn | The ARN of the flow log CloudWatch log group if one was created |
| internet\_gateway | The ID of the Internet Gateway |
| nat\_gateway | The ID of the NAT Gateway if one was created |
| nat\_gateway\_eip | The IP of the NAT Gateway if one was created |
| private\_route\_tables | The IDs for the private route tables |
| private\_subnets | The IDs for the private subnets |
| public\_route\_tables | The IDs for the public route tables |
| public\_subnets | The IDs of the public subnets |
| vpc\_id | The ID of the VPC |
| vpn\_gateway | The ID of the VPN gateway if one was created |

