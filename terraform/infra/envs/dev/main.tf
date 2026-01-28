module "vpc" {
  source = "../../modules/vpc"

  project = var.project
  env     = var.env

  vpc_cidr = var.vpc_cidr
  azs      = var.azs

  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  eks_cluster_name = var.eks_cluster_name

  tags = var.extra_tags
}

module "eks" {
  source = "../../modules/eks"

  project = var.project
  env     = var.env

  cluster_name = var.eks_cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_app_subnet_ids

  node_group_instance_types = var.node_group_instance_types
  node_group_desired_size   = var.node_group_desired_size
  node_group_min_size       = var.node_group_min_size
  node_group_max_size       = var.node_group_max_size

  tags = var.extra_tags
}
