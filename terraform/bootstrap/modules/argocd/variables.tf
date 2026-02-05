variable "namespace" {
  description = "Namespace where ArgoCD will be installed."
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "ArgoCD Helm chart version."
  type        = string
  default     = "9.3.7"
}

variable "create_namespace" {
  description = "Whether to create namespace via Terraform."
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Helm release timeout in seconds."
  type        = number
  default     = 600
}