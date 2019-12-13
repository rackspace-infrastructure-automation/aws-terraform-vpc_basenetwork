terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

module "vpc" {
  source = "../../module"

  name       = "Test2VPC"
  custom_azs = ["us-west-2a", "us-west-2b"]

  cidr_range             = "172.19.0.0/19"
  public_cidr_ranges     = ["172.19.16.0/22", "172.19.20.0/22", "172.19.24.0/22", "172.19.28.0/22"]
  public_subnets_per_az  = 2
  public_subnet_names    = ["Hello", "World"]
  private_cidr_ranges    = ["172.19.0.0/22", "172.19.4.0/22", "172.19.8.0/22", "172.19.12.0/22"]
  private_subnets_per_az = 2
  private_subnet_names   = ["Foo", "Bar"]
}
