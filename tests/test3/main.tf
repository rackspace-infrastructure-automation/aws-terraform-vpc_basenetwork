provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

module "vpc" {
  source = "~/repo"

  vpc_name  = "Test3VPC"
  build_vpn = true
  spoke_vpc = true
}
