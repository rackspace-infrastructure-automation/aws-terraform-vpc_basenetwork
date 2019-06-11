provider "aws" {
  version = "~> 1.2"
  region  = "us-west-2"
}

module "vpc" {
  source = "../../module"

  vpc_name   = "Test2VPC"
  custom_azs = ["us-west-2a", "us-west-2b"]

  cidr_range             = "10.0.0.0/19"
  public_cidr_ranges     = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22", "10.0.16.0/22"]
  public_subnets_per_az  = 2
  public_subnet_names    = ["Hello", "World"]
  private_cidr_ranges    = ["10.0.20.0/22", "10.0.24.0/22", "10.0.28.0/22", "10.0.32.0/22"]
  private_subnets_per_az = 2
  private_subnet_names   = ["Foo", "Bar"]
}
