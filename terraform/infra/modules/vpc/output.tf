output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR."
  value       = aws_vpc.this.cidr_block
}

output "igw_id" {
  description = "Internet Gateway ID."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID (single). Null if NAT disabled."
  value       = var.enable_nat_gateway ? aws_nat_gateway.this[0].id : null
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = [for az in var.azs : aws_subnet.public[az].id]
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs (recommended for EKS nodes/pods)."
  value       = [for az in var.azs : aws_subnet.private_app[az].id]
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs."
  value       = length(aws_subnet.private_data) > 0 ? [for az in var.azs : aws_subnet.private_data[az].id] : []
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_app_route_table_ids" {
  description = "Private app route table IDs (per AZ)."
  value       = { for az, rt in aws_route_table.private_app : az => rt.id }
}

output "private_data_route_table_ids" {
  description = "Private data route table IDs (per AZ)."
  value       = { for az, rt in aws_route_table.private_data : az => rt.id }
}