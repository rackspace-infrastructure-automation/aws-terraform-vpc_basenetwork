/**
 * # aws-terraform-vpc_basenetwork
 *
 *This module sets up basic network components for an account in a specific region. Optionally it will setup a basic VPN gateway and VPC flow logs.
 *
 *## Basic Usage
 *
 *```
 *module "vpc" {
 *  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.0.5"
 *
 *  vpc_name = "MyVPC"
 *}
 *```
 *
 * Full working references are available at [examples](examples)
 *## Default Resources
 *
 *By default only `vpc_name` is required to be set. Unless changed `aws_region` defaults to `us-west-2` and will need to be updated for other regions. `source` will also need to be declared depending on where the module lives. Given default settings the following resources are created:
 *
 * - VPC Flow Logs
 * - 2 AZs with public/private subnets from the list of 3 static CIDRs ranges available for each as defaults
 * - Public/private subnets with the count related to custom_azs if defined or region AZs automatically calculated by Terraform otherwise
 * - NAT Gateways will be created in each AZ's first public subnet
 * - EIPs will be created in all public subnets for NAT gateways to use
 * - Route Tables, including routes to NAT gateways if applicable
*/

locals {
  domain_name = "${var.domain_name == "" ? (data.aws_region.current.name == "us-east-1" ? "ec2.internal" : format("%s.compute.internal", data.aws_region.current.name)) : var.domain_name }"

  base_tags = {
    ServiceProvider = "Rackspace"
    Environment     = "${var.environment}"
  }

  azs = "${slice(coalescelist(var.custom_azs, data.aws_availability_zones.available.names), 0, var.az_count)}"
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

#############
# Basic VPC
#############

resource aws_vpc "vpc" {
  cidr_block                       = "${var.cidr_range}"
  instance_tenancy                 = "${var.default_tenancy}"
  enable_dns_hostnames             = "${var.enable_dns_hostnames}"
  enable_dns_support               = "${var.enable_dns_support}"
  assign_generated_ipv6_cidr_block = "${var.prepare_ipv6}"

  tags = "${merge(local.base_tags, map("Name", var.vpc_name), var.custom_tags)}"
}

resource aws_vpc_dhcp_options "dhcp_options" {
  domain_name         = "${local.domain_name}"
  domain_name_servers = "${var.domain_name_servers}"

  tags {
    ServiceProvider = "Rackspace"
    Name            = "${var.vpc_name}-DHCPOptions"
    Environment     = "${var.environment}"
  }
}

resource aws_vpc_dhcp_options_association "dhcp_options_association" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_options.id}"
}

resource aws_internet_gateway "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(local.base_tags, map("Name", format("%s-IGW", var.vpc_name)), var.custom_tags)}"
}

resource "aws_egress_only_internet_gateway" "egress_igw" {
  count  = "${var.enable_ipv6 == "true" ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
}

#############
# NAT Gateway
#############

resource aws_eip "nat_eip" {
  count      = "${var.build_nat_gateways ? var.az_count : 0}"
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
  tags       = "${merge(local.base_tags, map("Name", format("%s-NATEIP%d", var.vpc_name, count.index + 1)), var.custom_tags)}"
}

resource aws_nat_gateway "nat" {
  count         = "${var.build_nat_gateways ? var.az_count : 0}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${var.enable_ipv6 == "true" ? element(concat(aws_subnet.public_dualstack_subnet.*.id, list("")), count.index) : element(concat(aws_subnet.public_subnet.*.id, list("")), count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]
  tags          = "${merge(local.base_tags, map("Name", format("%s-NATGW%d", var.vpc_name, count.index + 1)), var.custom_tags)}"
}

#############
# Subnets
#############

resource aws_subnet "public_subnet" {
  count                           = "${var.enable_ipv6 == "false" ? var.az_count * var.public_subnets_per_az : 0}"
  vpc_id                          = "${aws_vpc.vpc.id}"
  cidr_block                      = "${var.public_cidr_ranges[count.index]}"
  availability_zone               = "${element(local.azs, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = "${var.enable_ipv6}"

  tags = "${merge(
    local.base_tags,
    map(
      "Name",
      format(
        "%s-%s%d",
        var.vpc_name,
        element(var.public_subnet_names, count.index / var.az_count),
        (count.index % var.az_count) + 1
      )
    ),
    var.custom_tags
  )}"
}

resource aws_subnet "private_subnet" {
  count                           = "${var.enable_ipv6 == "false" ? var.az_count * var.private_subnets_per_az : 0}"
  vpc_id                          = "${aws_vpc.vpc.id}"
  cidr_block                      = "${var.private_cidr_ranges[count.index]}"
  availability_zone               = "${element(local.azs, count.index)}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = "${var.enable_ipv6}"

  tags = "${merge(
    local.base_tags,
    map(
      "Name",
      format(
        "%s-%s%d",
        var.vpc_name,
        element(var.private_subnet_names, count.index / var.az_count),
        (count.index % var.az_count) + 1
      )
    ),
    var.custom_tags
  )}"
}

resource aws_subnet "public_dualstack_subnet" {
  count                           = "${var.enable_ipv6 == "true" ? var.az_count * var.public_subnets_per_az : 0}"
  vpc_id                          = "${aws_vpc.vpc.id}"
  cidr_block                      = "${var.public_cidr_ranges[count.index]}"
  ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index + 1)}"
  availability_zone               = "${element(local.azs, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = "${var.enable_ipv6}"

  tags = "${merge(
    local.base_tags,
    map(
      "Name",
      format(
        "%s-%s%d",
        var.vpc_name,
        element(var.public_subnet_names, count.index / var.az_count),
        (count.index % var.az_count) + 1
      )
    ),
    var.custom_tags
  )}"
}

resource aws_subnet "private_dualstack_subnet" {
  count                           = "${var.enable_ipv6 == "true" ? var.az_count * var.private_subnets_per_az : 0}"
  vpc_id                          = "${aws_vpc.vpc.id}"
  cidr_block                      = "${var.private_cidr_ranges[count.index]}"
  ipv6_cidr_block                 = "${var.enable_ipv6 == "true" ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index + 100) : ""}"
  availability_zone               = "${element(local.azs, count.index)}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = "${var.enable_ipv6}"

  tags = "${merge(
    local.base_tags,
    map(
      "Name",
      format(
        "%s-%s%d",
        var.vpc_name,
        element(var.private_subnet_names, count.index / var.az_count),
        (count.index % var.az_count) + 1
      )
    ),
    var.custom_tags
  )}"
}

#########################
# Route Tables and Routes
#########################

resource aws_route_table "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(local.base_tags, map("Name", format("%s-PublicRouteTable", var.vpc_name)), var.custom_tags)}"
}

resource aws_route_table "private_route_table" {
  count  = "${var.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(local.base_tags, map("Name", format("%s-PrivateRouteTable%d", var.vpc_name, count.index + 1)), var.custom_tags)}"
}

resource aws_route "public_routes" {
  route_table_id         = "${aws_route_table.public_route_table.id}"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource aws_route "private_routes" {
  count                  = "${var.build_nat_gateways ? var.az_count : 0}"
  route_table_id         = "${element(aws_route_table.private_route_table.*.id, count.index)}"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
}

resource aws_route "public_ipv6_routes" {
  count                       = "${var.enable_ipv6 == "true" ? 1 : 0}"
  route_table_id              = "${aws_route_table.public_route_table.id}"
  gateway_id                  = "${aws_internet_gateway.igw.id}"
  destination_ipv6_cidr_block = "::/0"
}

resource aws_route "private_ipv6_routes" {
  count                       = "${var.enable_ipv6 == "true" ? var.az_count : 0}"
  route_table_id              = "${element(aws_route_table.private_route_table.*.id, count.index)}"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.egress_igw.id}"
  destination_ipv6_cidr_block = "::/0"
}

resource aws_route_table_association "public_route_association" {
  count          = "${var.enable_ipv6 == "false" ? var.az_count * var.public_subnets_per_az : 0}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource aws_route_table_association "private_route_association" {
  count          = "${var.enable_ipv6 == "false" ? var.az_count * var.private_subnets_per_az : 0}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}

resource aws_route_table_association "public_ipv6_route_association" {
  count          = "${var.enable_ipv6 == "true" ? var.az_count * var.public_subnets_per_az : 0}"
  subnet_id      = "${element(aws_subnet.public_dualstack_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource aws_route_table_association "private_ipv6_route_association" {
  count          = "${var.enable_ipv6 == "true" ? var.az_count * var.private_subnets_per_az : 0}"
  subnet_id      = "${element(aws_subnet.private_dualstack_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}

#####
# VPN
#####

resource aws_vpn_gateway "vpn_gateway" {
  count  = "${var.build_vpn ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(local.base_tags, map("Name", format("%s-VPNGateway", var.vpc_name), "transitvpc:spoke", var.spoke_vpc), var.custom_tags)}"
}

resource aws_vpn_gateway_route_propagation "vpn_routes_public" {
  count          = "${var.build_vpn ? 1 : 0}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource aws_vpn_gateway_route_propagation "vpn_routes_private" {
  count          = "${var.build_vpn ? length(var.private_cidr_ranges) : 0}"
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
  route_table_id = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}

###########
# Flow Logs
###########

resource aws_flow_log "main" {
  count          = "${var.build_flow_logs ? 1 : 0}"
  log_group_name = "${aws_cloudwatch_log_group.flowlog_group.name}"
  iam_role_arn   = "${aws_iam_role.flowlog_role.arn}"
  vpc_id         = "${aws_vpc.vpc.id}"
  traffic_type   = "ALL"
}

resource aws_cloudwatch_log_group "flowlog_group" {
  count = "${var.build_flow_logs ? 1 : 0}"
  name  = "${var.vpc_name}-FlowLogs"
}

resource aws_iam_role "flowlog_role" {
  count = "${var.build_flow_logs ? 1 : 0}"
  name  = "${var.vpc_name}-FlowLogsRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource aws_iam_role_policy "flowlog_policy" {
  count = "${var.build_flow_logs ? 1 : 0}"
  name  = "${var.vpc_name}-FlowLogsPolicy"
  role  = "${aws_iam_role.flowlog_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.flowlog_group.arn}"
    }
  ]
}
EOF
}
