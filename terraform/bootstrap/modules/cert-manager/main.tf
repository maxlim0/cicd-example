############################
# Kubernetes SA for cert-manager (with Pod Identity)
############################

resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_service_account_v1" "cert_manager" {
  metadata {
    name      = "cert-manager"
    namespace = "cert-manager"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.cert_manager.arn
    }
  }

  depends_on = [kubernetes_namespace_v1.cert_manager]
}