terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-west-2"
}

module "vpc" {
  source = "../../module"

  name = "Test1VPC"
}
