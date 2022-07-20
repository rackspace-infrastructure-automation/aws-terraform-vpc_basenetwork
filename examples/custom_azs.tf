terraform {
  required_version = ">= 0.13.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "git::https://github.com/rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork.git//?ref=v0.12.8"

  name       = "MyVPC"
  custom_azs = ["us-west-2a", "us-west-2b"]

  cidr_range             = "10.0.0.0/19"
  public_cidr_ranges     = ["10.0.4.0/22", "10.0.8.0/22"]
  public_subnets_per_az  = 1
  private_cidr_ranges    = ["10.0.12.0/22", "10.0.16.0/22"]
  private_subnets_per_az = 1
}
