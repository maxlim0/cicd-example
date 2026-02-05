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
    file("${path.module}/argocd-values.yaml")
  ]

  # depends_on = [
  #   kubernetes_namespace_v1.this
  # ]
}

resource "time_sleep" "wait_for_argocd_secret" {
  depends_on = [helm_release.argocd]

  create_duration = "30s"
}

data "kubernetes_secret_v1" "argocd_initial_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [time_sleep.wait_for_argocd_secret]
}