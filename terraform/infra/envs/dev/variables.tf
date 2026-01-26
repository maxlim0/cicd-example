variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_data_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

# Optional for future EKS tagging, can be left null for now.
variable "eks_cluster_name" {
  type    = string
  default = null
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}