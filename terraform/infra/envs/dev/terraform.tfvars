region  = "us-east-1"
project = "lab-platform"
env     = "dev"

vpc_cidr = "10.0.0.0/16"

azs = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs = [
  "10.0.0.0/20",
  "10.0.16.0/20"
]

private_app_subnet_cidrs = [
  "10.0.32.0/20",
  "10.0.48.0/20"
]

private_data_subnet_cidrs = [
  "10.0.64.0/20",
  "10.0.80.0/20"
]

enable_nat_gateway = true
single_nat_gateway = true

# eks_cluster_name = "lab-eks" 
# extra_tags = {
#   Owner = "maxim"
# }