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
## the subnets output, to make sure the routes are created first so bootstraping will wait for the routes.

output "public_subnets" {
  value       = "${aws_subnet.public_subnet.*.id}"
  description = "The IDs of the public subnets"

  depends_on = ["aws_route_table_association.public_route_association"]
}

output "private_subnets" {
  value       = "${aws_subnet.private_subnet.*.id}"
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
