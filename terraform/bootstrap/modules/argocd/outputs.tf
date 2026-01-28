output "namespace" {
  description = "ArgoCD namespace."
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name."
  value       = helm_release.argocd.name
}

output "chart_version" {
  description = "Installed ArgoCD chart version."
  value       = helm_release.argocd.version
}