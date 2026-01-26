locals {
  name = "${var.project}-${var.env}"

  common_tags = merge (
    {
        Project     = var.project
        Enviroument = var.env
        ManagedBy   = "terraform"
    },
    var.tags
  )

  # EKS-related subnet tags (optional)
  eks_public_subnet_tags = var.eks_cluster_name == null ? {} : {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  eks_private_subnet_tags = var.eks_cluster_name == null ? {} : {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }

}
