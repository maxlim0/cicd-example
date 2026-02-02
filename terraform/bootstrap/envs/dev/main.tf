module "argocd" {
  source = "../../modules/argocd"

  namespace     = "argocd"
  chart_version = "6.7.18"
}

module "cert-manager" {
  source = "../../modules/cert-manager"

  cert_manager_role_arn = data.terraform_remote_state.infra.outputs.cert_manager_role_arn
}
