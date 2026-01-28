module "argocd" {
  source = "../../modules/argocd"

  namespace     = "argocd"
  chart_version = "6.7.18"
}