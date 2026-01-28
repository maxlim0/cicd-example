variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.34"
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS cluster and node group (private recommended)."
  type        = list(string)
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS API endpoint is publicly accessible."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Whether the EKS API endpoint is privately accessible."
  type        = bool
  default     = false
}

variable "node_group_name" {
  description = "Managed node group name."
  type        = string
  default     = "main"
}

variable "node_group_instance_types" {
  description = "EC2 instance types for node group."
  type        = list(string)
  default     = ["m1.large","t3.medium", "t3.large"]
}

variable "node_group_capacity_type" {
  description = "ON_DEMAND or SPOT."
  type        = string
  default     = "SPOT"
}

variable "node_group_desired_size" {
  type    = number
  default = 1
}

variable "node_group_min_size" {
  type    = number
  default = 1
}

variable "node_group_max_size" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}