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