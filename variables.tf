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
  default     = "172.18.0.0/16"
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
    "172.18.168.0/22",
    "172.18.172.0/22",
    "172.18.176.0/22",
  ]
}

variable "private_cidr_ranges" {
  description = "An array of CIDR ranges to use for private subnets"
  type        = "list"

  default = [
    "172.18.0.0/21",
    "172.18.8.0/21",
    "172.18.16.0/21",
  ]
}

#######################
# Conditional Resources
#######################

variable "build_flow_logs" {
  description = "Whether or not to build flow log components"
  default     = "false"
  type        = "string"
}

variable "build_nat_gateways" {
  description = "Whether or not to build a NAT gateway per AZ"
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
