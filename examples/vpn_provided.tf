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

  name      = "MyVPC"
  build_vpn = true
  spoke_vpc = true
}
