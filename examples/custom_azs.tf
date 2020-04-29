terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.12.2"

  name       = "MyVPC"
  custom_azs = ["us-west-2a", "us-west-2b"]

  cidr_range             = "10.0.0.0/19"
  public_cidr_ranges     = ["10.0.4.0/22", "10.0.8.0/22"]
  public_subnets_per_az  = 1
  private_cidr_ranges    = ["10.0.12.0/22", "10.0.16.0/22"]
  private_subnets_per_az = 1
}
