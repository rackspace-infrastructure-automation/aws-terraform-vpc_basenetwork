provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

module "vpc" {
  source = "../../module"

  vpc_name = "Test3VPC"

  enable_ipv6         = "true"
  enable_public_ipv6  = "true"
  enable_private_ipv6 = "true"
}
