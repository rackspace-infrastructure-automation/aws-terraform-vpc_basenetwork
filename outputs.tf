output "default_sg" {
  description = "The ID of the default SG for the VPC"
  value       = aws_vpc.vpc.default_security_group_id
}

output "flowlog_log_group_arn" {
  description = "The ARN of the flow log CloudWatch log group if one was created"
  value       = join(" ", aws_cloudwatch_log_group.flowlog_group.*.arn)
}

output "internet_gateway" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.*.id
}

output "nat_gateway" {
  description = "The ID of the NAT Gateway if one was created"
  value       = aws_nat_gateway.nat.*.id
}

output "nat_gateway_eip" {
  description = "The IP of the NAT Gateway if one was created"
  value       = aws_eip.nat_eip.*.id
}

output "private_route_tables" {
  description = "The IDs for the private route tables"
  value       = aws_route_table.private_route_table.*.id
}

output "private_subnets" {
  description = "The IDs for the private subnets"
  value       = aws_subnet.private_subnet.*.id

  depends_on = [aws_route_table_association.private_route_association]
}

output "public_route_tables" {
  description = "The IDs for the public route tables"
  value       = aws_route_table.public_route_table.*.id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet.*.id

  depends_on = [aws_route_table_association.public_route_association]
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpn_gateway" {
  description = "The ID of the VPN gateway if one was created"
  value       = join(" ", aws_vpn_gateway.vpn_gateway.*.id)
}
