.PHONY: up down deploy

up:
	civo kubernetes create interesting-times-gang -n3 --wait --remove-applications=traefik 
	civo kubernetes config interesting-times-gang -s
down:
	civo kubernetes delete interesting-times-gang
helm-repos:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add jetstack https://charts.jetstack.io
	helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
	helm repo update
install: helm-repos pre-install helm-install post-install
helm-install: 
	helm install prom prometheus-community/kube-prometheus-stack -n kube-system
	helm install cert-manager --namespace cert-manager --version v1.0.2 jetstack/cert-manager --set=installCRDs=true
	helm install nginx ingress-nginx/ingress-nginx --version 3.3.0 --namespace ingress-nginx
	helm install gatekeeper gatekeeper/gatekeeper -n kube-system
pre-install:
	kubectl create namespace cert-manager
	kubectl create namespace ingress-nginx
get-grafana-pass:
	kubectl get secret --namespace kube-system prom-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
post-install:
	kubectl wait --for=condition=ready pods -l "app=webhook" -n cert-manager
	kubectl apply -f resources/issuer.yaml
	kubectl apply -f resources/cluster-ingress.yaml -n kube-system
