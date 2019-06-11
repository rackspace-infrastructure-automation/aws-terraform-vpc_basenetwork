#################
# General Options
#################

variable "environment" {
  description = "Application environment for which this network is being created. e.g. Development/Production"
  type        = "string"
  default     = "Development"
}

variable "custom_tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = "map"
  default     = {}
}

##################
# VPC Core Options
##################

variable "vpc_name" {
  description = "Name for the VPC"
  type        = "string"
}

variable "cidr_range" {
  description = "CIDR range for the VPC"
  default     = "172.18.0.0/19"
  type        = "string"
}

variable "default_tenancy" {
  description = "Default tenancy for instances. Either multi-tenant (default) or single-tenant (dedicated)"
  default     = "default"
  type        = "string"
}

variable "domain_name" {
  description = "Custom domain name for the VPC"
  default     = ""
  type        = "string"
}

variable "domain_name_servers" {
  description = "Array of custom domain name servers"
  type        = "list"
  default     = ["AmazonProvidedDNS"]
}

variable "enable_dns_hostnames" {
  description = "Whether or not to enable DNS hostnames for the VPC"
  type        = "string"
  default     = "true"
}

variable "enable_dns_support" {
  description = "Whether or not to enable DNS support for the VPC"
  type        = "string"
  default     = "true"
}

#####################
# Subnet Core Options
#####################

variable "custom_azs" {
  description = "A list of AZs that VPC resources will reside in"
  type        = "list"
  default     = []
}

variable "az_count" {
  description = "Number of AZs to utilize for the subnets"
  type        = "string"
  default     = "2"
}

variable "public_cidr_ranges" {
  description = "An array of CIDR ranges to use for public subnets"
  type        = "list"

  default = [
    "172.18.0.0/22",
    "172.18.4.0/22",
    "172.18.8.0/22",
  ]
}

variable "public_subnets_per_az" {
  description = <<EOF
Number of public subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`,
should not exceed the length of the `public_cidr_ranges` list!
EOF

  type    = "string"
  default = "1"
}

variable "public_subnet_names" {
  description = <<EOF
Text that will be included in generated name for public subnets. Given the default value of `["Public"]`, subnet
names in the form \"<vpc_name>-Public<count+1>\", e.g. \"MyVpc-Public1\" will be produced. Otherwise, given a
list of names with length the same as the value of `az_count`, the first `az_count` subnets will be named using
the first string in the list, the second `az_count` subnets will be named using the second string, and so on.
EOF

  type    = "list"
  default = ["Public"]
}

variable "public_subnet_tags" {
  description = "A list of maps containing tags to be applied to public subnets. List should either be the same length as the number of AZs to apply different tags per set of subnets, or a length of 1 to apply the same tags across all public subnets."
  type        = "list"

  default = [
    {},
  ]
}

variable "private_cidr_ranges" {
  description = "An array of CIDR ranges to use for private subnets"
  type        = "list"

  default = [
    "172.18.16.0/22",
    "172.18.20.0/22",
    "172.18.24.0/22",
  ]
}

variable "private_subnets_per_az" {
  description = <<EOF
Number of private subnets to create in each AZ. NOTE: This value, when multiplied by the value of `az_count`,
should not exceed the length of the `private_cidr_ranges` list!
EOF

  type    = "string"
  default = "1"
}

variable "private_subnet_names" {
  description = <<EOF
Text that will be included in generated name for private subnets. Given the default value of `["Private"]`, subnet
names in the form \"<vpc_name>-Private<count+1>\", e.g. \"MyVpc-Public2\" will be produced. Otherwise, given a
list of names with length the same as the value of `az_count`, the first `az_count` subnets will be named using
the first string in the list, the second `az_count` subnets will be named using the second string, and so on.
EOF

  type    = "list"
  default = ["Private"]
}

variable "private_subnet_tags" {
  description = "A list of maps containing tags to be applied to private subnets. List should either be the same length as the number of AZs to apply different tags per set of subnets, or a length of 1 to apply the same tags across all private subnets."
  type        = "list"

  default = [
    {},
  ]
}

#######################
# Conditional Resources
#######################

variable "build_flow_logs" {
  description = "Whether or not to build flow log components in cloud watch logs"
  default     = "false"
  type        = "string"
}

variable "build_s3_flow_logs" {
  description = "Whether or not to build flow log components in s3"
  default     = "false"
  type        = "string"
}

variable "logging_bucket_name" {
  description = "Bucket name to store s3 flow logs. If empty, to create random bucket name. In conjuction with build_s3_flow_logs"
  type        = "string"
  default     = ""
}

variable "logging_bucket_access_control" {
  description = "Define ACL for Bucket from one of the [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl): private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, bucket-owner-full-control, log-delivery-write"
  type        = "string"
  default     = "bucket-owner-full-control"
}

variable "logging_bucket_retention" {
  description = "The number of days to retain load balancer logs. 0 to ratain forever."
  type        = "string"
  default     = "14"
}

variable "logging_bucket_prefix" {
  description = "The prefix for the location in the S3 bucket. If you don't specify a prefix, the access logs are stored in the root of the bucket."
  type        = "string"
  default     = ""
}

variable "logging_bucket_encryption" {
  description = "Enable default bucket encryption. i.e. AES256 | aws:kms"
  type        = "string"
  default     = "AES256"
}

variable "logging_bucket_encryption_kms_mster_key" {
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms."
  type        = "string"
  default     = ""
}

variable "logging_bucket_force_destroy" {
  description = "Whether all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. ie. true"
  type        = "string"
  default     = "false"
}

variable "build_igw" {
  description = <<EOF
Whether or not to build an internet gateway.  If disabled, no public subnets or route tables, internet gateway,
or NAT Gateways will be created.
EOF

  default = "true"
  type    = "string"
}

variable "build_nat_gateways" {
  description = "Whether or not to build a NAT gateway per AZ.  if `build_igw` is set to false, this value is ignored."
  default     = "true"
  type        = "string"
}

variable "build_vpn" {
  description = "Whether or not to build a VPN gateway"
  default     = "false"
  type        = "string"
}

variable "spoke_vpc" {
  description = "Whether or not the VPN gateway is a spoke of a Transit VPC"
  default     = "false"
  type        = "string"
}
