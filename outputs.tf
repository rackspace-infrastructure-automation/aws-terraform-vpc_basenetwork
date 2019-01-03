##################
# Core VPC Outputs
##################

output "vpc_id" {
  value       = "${aws_vpc.vpc.id}"
  description = "The ID of the VPC"
}

output "default_sg" {
  value       = "${aws_vpc.vpc.default_security_group_id}"
  description = "The ID of the default SG for the VPC"
}

output "internet_gateway" {
  value       = "${aws_internet_gateway.igw.*.id}"
  description = "The ID of the Internet Gateway"
}

##################
# Subnet Outputs
##################

## Since terraform will build across all modules synchronously, there is a possibility instances will be
## built and bootstrapping will fail before routes are created. Therefore we will add the dependon for
## the subnets output, to make sure the routes are created first so bootstrapping will wait for the routes.

output "public_subnets" {
  value       = "${var.enable_ipv6 == "false" ? var.enable_public_ipv6 == "false" ? element(concat(aws_subnet.public_subnet.*.id, list("")), 0) : "" : ""}"
  description = "The IDs of the public subnets"

  depends_on = ["aws_route_table_association.public_route_association"]
}

output "private_subnets" {
  value       = "${var.enable_ipv6 == "false" ? var.enable_private_ipv6 == "false" ? element(concat(aws_subnet.private_subnet.*.id, list("")), 0) : "" : ""}"
  description = "The IDs for the private subnets"

  depends_on = ["aws_route_table_association.private_route_association"]
}

output "public_route_tables" {
  value       = "${aws_route_table.public_route_table.*.id}"
  description = "The IDs for the public route tables"
}

output "private_route_tables" {
  value       = "${aws_route_table.private_route_table.*.id}"
  description = "The IDs for the private route tables"
}

##############################
# Conditional Resource Outputs
##############################

output "vpn_gateway" {
  value       = "${ join(" ", aws_vpn_gateway.vpn_gateway.*.id) }"
  description = "The ID of the VPN gateway if one was created"
}

output "nat_gateway" {
  value       = "${aws_nat_gateway.nat.*.id}"
  description = "The ID of the NAT Gateway if one was created"
}

output "nat_gateway_eip" {
  value       = "${aws_eip.nat_eip.*.id}"
  description = "The IP of the NAT Gateway if one was created"
}

output "flowlog_log_group_arn" {
  value       = "${ join(" ", aws_cloudwatch_log_group.flowlog_group.*.arn) }"
  description = "The ARN of the flow log CloudWatch log group if one was created"
}

# IPv6 Conditional Resource Outputs

output "ipv6_association_id" {
  value       = "${var.enable_ipv6 == "true" ? aws_vpc.vpc.ipv6_association_id : ""}"
  description = "The ID of the VPC IPv6 Association ID if one was created"
}

output "ipv6_cidr_block" {
  value       = "${var.enable_ipv6 == "true" ? aws_vpc.vpc.ipv6_cidr_block : ""}"
  description = "The IPv6 CIDR block of the VPC if one was created"
}

output "public_dualstack_subnets" {
  value       = "${var.enable_ipv6 == "true" ? var.enable_public_ipv6 == "true" ? element(concat(aws_subnet.public_dualstack_subnet.*.id, list("")), 0) : "" : ""}"
  description = "The IDs of the public dual stack subnets"

  depends_on = ["aws_route_table_association.public_route_association"]
}

output "private_dualstack_subnets" {
  value       = "${var.enable_ipv6 == "true" ? var.enable_private_ipv6 == "true" ? element(concat(aws_subnet.private_dualstack_subnet.*.id, list("")), 0) : "" : ""}"
  description = "The IDs for the private dual stack subnets"

  depends_on = ["aws_route_table_association.private_route_association"]
}

output "public_subnet_ipv6_cidr_block_association_ids" {
  value       = "${var.enable_ipv6 == "true" ? var.enable_public_ipv6 == "true" ? element(concat(aws_subnet.public_dualstack_subnet.*.ipv6_cidr_block_association_id, list("")), 0) : "" : ""}"
  description = "The association IDs of the IPv6 CIDR block of the public subnets"

  depends_on = ["aws_route_table_association.public_route_association"]
}

output "private_subnet_ipv6_cidr_block_association_ids" {
  value       = "${var.enable_ipv6 == "true" ? var.enable_private_ipv6 == "true" ? element(concat(aws_subnet.private_dualstack_subnet.*.ipv6_cidr_block_association_id, list("")), 0) : "" : ""}"
  description = "The association IDs of the IPv6 CIDR block for the private subnets"

  depends_on = ["aws_route_table_association.private_route_association"]
}

output "egress_only_internet_gateway_id" {
  value       = "${var.enable_ipv6 == "true" ? var.enable_private_ipv6 == "true" ? element(concat(aws_egress_only_internet_gateway.egress_igw.*.id, list("")), 0) : "" : ""}"
  description = "The ID of the Egress Only Internet Gateway if one was created"
}
