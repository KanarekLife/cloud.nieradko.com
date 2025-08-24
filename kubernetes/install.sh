echo "Installing ArgoCD"

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd -f argocd/values.yml --create-namespace --namespace argocd --atomic

