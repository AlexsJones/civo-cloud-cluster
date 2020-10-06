.PHONY: up down deploy

up:
	civo kubernetes create interesting-times-gang -n3 --wait --remove-applications=traefik 
	civo kubernetes config interesting-times-gang -s
down:
	civo kubernetes delete interesting-times-gang
helm-repos:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add jetstack https://charts.jetstack.io
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
	helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
	helm repo update
install: helm-repos pre-install post-install
pre-install:
	kubectl create ns argocd || true
	kubectl create ns ingress-nginx || true
	kubectl create ns cert-manager || true
	helm install cert-manager --namespace cert-manager --version v1.0.2 jetstack/cert-manager --set=installCRDs=true
	helm install nginx ingress-nginx/ingress-nginx --version 3.3.0 --namespace ingress-nginx
	helm install argo argo/argo-cd -n argocd --set=server.extraArgs={--insecure}
post-install:
	sleep 20
	kubectl wait --for=condition=ready pods -l "app=webhook" -n cert-manager
	kubectl wait --for=condition=ready pods -l "app.kubernetes.io/name=ingress-nginx" -n ingress-nginx
	kubectl apply -f resources/ingress/issuer.yaml 
	kubectl apply -f resources/ingress/argocd-ingress-crystalbasilica.yaml -n argocd
	kubectl apply -f resources/application-bootstrap.yaml -n argocd
get-argocd-password:
	kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
