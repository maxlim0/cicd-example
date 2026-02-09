# AWS EKS GitOps Platform (Terraform + Argo CD)

Production-style infrastructure and GitOps setup on AWS.

This repository shows an end-to-end workflow for building and operating Kubernetes infrastructure with:
- AWS networking and managed Kubernetes (EKS)
- Terraform modules and environment separation
- EKS add-ons and pod identity integrations
- Route53 DNS automation for platform endpoints
- Argo CD App of Apps pattern
- Helm-based platform applications

## Architecture at a Glance

1. Terraform creates foundational AWS infrastructure:
- VPC, subnets, routing, NAT
- EKS cluster and managed node groups
- IAM and EKS add-ons (including pod identity-based integrations)
- Route53-integrated identities for ExternalDNS and cert-manager

2. Terraform bootstrap layer configures in-cluster essentials:
- Argo CD installation via Helm
- cert-manager bootstrap resources for ACME/DNS-01 certificates

3. Argo CD manages platform apps from Git:
- `system-root` / App of Apps points to `gitops/clusters/dev/system`
- cert-manager, ingress-nginx, and related manifests are reconciled automatically
- DNS records and TLS issuance are aligned with Route53 + cert-manager flow

## DNS & TLS Flow

- ExternalDNS updates Route53 records from Kubernetes ingress/service state.
- cert-manager requests and renews certificates via ACME DNS-01.
- Route53 is used as the DNS challenge provider for certificate validation.
- Ingress resources consume issued TLS secrets for HTTPS endpoints.

## Repository Layout

```text
.github/workflows/          # CI Terraform checks and plan execution
terraform/
  infra/                    # AWS infra: VPC, EKS, add-ons
  bootstrap/                # Cluster bootstrap: Argo CD, cert-manager wiring
gitops/clusters/dev/system/ # Argo CD applications and platform manifests
docs/                       # Operational notes
```

## Delivery Flow

- Infrastructure changes are managed through Terraform code.
- GitHub Actions runs Terraform validation/plan on PRs.
- Changes merged to `main` trigger the infrastructure pipeline run.
- Argo CD continuously reconciles Kubernetes state from this repository.
- cert-manager handles certificate lifecycle, using Route53 for DNS challenge validation.

## Core Stack

- AWS (VPC, IAM, Route53, EKS)
- Terraform (modularized infra and bootstrap layers)
- Argo CD (GitOps controller)
- Helm (application packaging)
- cert-manager + ingress-nginx (TLS and ingress foundation)

## Environment

Current layout is focused on `dev` under:
- `terraform/infra/envs/dev`
- `terraform/bootstrap/envs/dev`
- `gitops/clusters/dev/system`

This structure is ready to be extended for additional environments with the same module pattern.
