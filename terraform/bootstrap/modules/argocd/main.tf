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

resource "time_sleep" "wait_for_argocd_secret" {
  depends_on = [helm_release.argocd]

  create_duration = "30s"
}

data "kubernetes_secret" "argocd_initial_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [time_sleep.wait_for_argocd_secret]
}