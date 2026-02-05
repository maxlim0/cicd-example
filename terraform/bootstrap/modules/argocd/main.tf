# resource "kubernetes_namespace_v1" "this" {
#   count = var.create_namespace ? 1 : 0

#   metadata {
#     name = var.namespace

#     labels = {
#       "app.kubernetes.io/part-of" = "argocd"
#       "platform.layer"            = "bootstrap"
#     }
#   }
# }

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = var.namespace

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  create_namespace = true
  timeout          = var.timeout
  wait             = true
  atomic           = true
  cleanup_on_fail  = true

  values = [
    file("${path.module/argocd-values.yaml}")
  ]

  depends_on = [
    kubernetes_namespace_v1.this
  ]
}