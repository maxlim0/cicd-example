aws eks update-kubeconfig --region us-east-1 --name lab-eks-dev


### argo
localport
kubectl port-forward svc/argocd-server -n argocd 8080:443

get password:
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

rm all apps
kubectl -n argocd get applications -o name | xargs kubectl -n argocd delete

rm with finalizer
kubectl patch application cert-manager \
  -n argocd \
  -p '{"metadata":{"finalizers":["resources-finalizer.argocd.argoproj.io"]}}' \
  --type merge

kubectl delete application cert-manager -n argocd
###



### TODO
 - PVC
 - Karpenter
 - Monitoring
 - CloudFlare VPN host / ZeroTrust
 - add Helm Secrets intergrtation for ArgoCD admin stable password 