############################
# Kubernetes SA for cert-manager (with Pod Identity)
############################

resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}
