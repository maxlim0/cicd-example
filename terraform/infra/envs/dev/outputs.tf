output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  value = module.vpc.private_data_subnet_ids
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_app_route_table_ids" {
  value = module.vpc.private_app_route_table_ids
}

output "private_data_route_table_ids" {
  value = module.vpc.private_data_route_table_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}