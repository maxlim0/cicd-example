variable "project" {
  description = "Project name, used for naming/tagging."
  type        = string
}

variable "env" {
  description = "Environment name (dev/stage/prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "azs" {
  description = "List of availability zones."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (one per AZ)."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private app subnet CIDRs (one per AZ)."
  type        = list(string)
}

variable "private_data_subnet_cidrs" {
  description = "Private data subnet CIDRs (one per AZ)."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway(s)."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "If true, create a single NAT Gateway in the first public subnet."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "eks_cluster_name" {
  description = "If set, apply recommended EKS tags on subnets."
  type        = string
  default     = null
}

variable "tags" {
  description = "Extra tags to apply to all resources."
  type        = map(string)
  default     = {}
}