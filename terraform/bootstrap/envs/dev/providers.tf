data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "maxim-lab-tf-state-978937106980-us-east-1"
    key    = "lab-infra/dev/vpc.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.infra.outputs.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.infra.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.infra.outputs.eks_cluster_ca_certificate
  )
  token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.infra.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.infra.outputs.eks_cluster_ca_certificate
    )
    token = data.aws_eks_cluster_auth.this.token
  }
}