provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

module "vpc" {
  source              = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.0.6"
  vpc_name            = "MyVPC"
  prepare_ipv6        = "true"
  enable_ipv6         = "true"
  enable_public_ipv6  = "true"
  enable_private_ipv6 = "true"
}
