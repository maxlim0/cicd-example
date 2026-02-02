aws eks update-kubeconfig --region us-east-1 --name lab-eks-dev


### argo
localport
kubectl port-forward svc/argocd-server -n argocd 8080:443
get password:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
###


### TODO
 - PVC
 - Karpenter
 - Monitoring
 - CloudFlare VPN host / ZeroTrust