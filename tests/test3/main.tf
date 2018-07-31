provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

module "vpc" {
  source = "~/repo"

  vpc_name  = "MyVPC"
  build_vpn = true
  spoke_vpc = true
}
