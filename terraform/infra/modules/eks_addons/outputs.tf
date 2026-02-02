output "external_dns_role_arn" {
  description = "IAM role ARN used by ExternalDNS via Pod Identity"
  value       = aws_iam_role.external_dns.arn
}

output "cert_manager_role_arn" {
  value = aws_iam_role.cert_manager.arn
}