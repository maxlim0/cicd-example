variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for ExternalDNS"
  type        = string
}