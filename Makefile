# set default shell
SHELL := $(shell which bash)
FOLDER=$$(pwd)
# default shell options
.SHELLFLAGS = -c
NO_COLOR=\\e[39m
OK_COLOR=\\e[32m
ERROR_COLOR=\\e[31m
WARN_COLOR=\\e[33m
.SILENT: ;
APP_NAME=paulb314/uploader-app
APP_TAG=latest
APP_ARG=dev
DOCKER_IMAGE=quay.io/dreamquark/devops
DOCKER_TAG=latest

CHART_NAME=devops-chart
CHART_FOLDER=helm-chart
CHART_RELEASE=0.1.0

DNS_SOLVER=dns01-solver
PROJECT_ID=terraform-test-319307
CLUSTER_NAME=demo-cluster
CLUSTER_ZONE=europe-west1
DOMAIN_NAME=quelle-indignite.com
NAMESPACE=polo

default: help;   # default target

help: ## display commands help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

up: ## Start all components
	echo "Start all components"
	docker-compose up -d --build
.PHONY: up

ps: ## Start all components
	echo "Start all components"
	docker-compose ps
.PHONY: ps

build-app:
	docker build -t $(APP_NAME):$(APP_TAG) --build-arg ENV_APP=$(APP_ARG) -f uploader-app/Dockerfile uploader-app
.PHONY: build-app

build-app-prod:
	$(MAKE) build-app APP_ARG=prod
.PHONY: build-app-prod

deploy-app: build-app-prod
	docker push $(APP_NAME):$(APP_TAG)
.PHONY: deploy-app

vendor:
	docker exec node-app npm install
.PHONY: vendor

stop: ## Start all components
	docker-compose stop
.PHONY: stop

rm: ## Start all components
	echo "Start all components"
	docker-compose rm -f
.PHONY: rm

# Kubernetes
install-nginx: ##
	helm repo add nginx-stable https://helm.nginx.com/stable
	helm repo update
	helm install my-release nginx-stable/nginx-ingress
.PHONY: install-nginx

apply-kube:
	kubectl apply -f ./kubernetes
.PHONY: apply-kube

clear-chart:
	rm -f $(CHART_FOLDER)/charts/* devops-test-0.1.0.tgz
.PHONY: clear-chart

uninstall-chart:
	$([ $(echo "$(helm uninstall $(CHART_NAME))" | grep -c $(CHART_NAME)) == 0 ] && echo "Nothing to do" || helm uninstall $(CHART_NAME))
.PHONY: uninstall-chart

package-chart:
	$(MAKE) clear-chart
	helm package --dependency-update $(CHART_FOLDER) 
.PHONY: package-chart

vendor-chart:
	helm upgrade --install $(CHART_RELEASE) $(CHART_FOLDER)

install-chart: ## 
	$(MAKE) package-chart $(CHART_FOLDER)
	helm install  $(CHART_NAME) $(CHART_FOLDER)
.PHONY: install-chart

debug-chart:
	$(MAKE) clear-chart
	$(MAKE) uninstall-chart
	$(MAKE) package-chart
	helm install --dry-run --debug $(CHART_NAME) $(CHART_FOLDER) > logs
.PHONY: debug-chart

template-chart: ## helm template commands
	$(MAKE) clear-chart
	$(MAKE) package-chart
	helm template --debug $(CHART_NAME) devops-test-0.1.0.tgz > test.yaml
.PHONY: template

install-cert-manager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm install cert-manager jetstack/cert-manager \
	--namespace cert-manager --create-namespace \
    --set extraArgs='{--dns01-recursive-nameservers-only,--dns01-recursive-nameservers=8.8.8.8:53\\,1.1.1.1:53}' \
	--set installCRDs=true \
	--version v1.4.1
.PHONY: install-cert-manager

install-eck-chart:
	kubectl apply -f https://download.elastic.co/downloads/eck/1.0.1/all-in-one.yaml
.PHONY: install-eck-chart

install-olm:
	kubectl -n $(NAMESPACE) apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.14.1/olm.yaml
.PHONY: install-olm

install-kubed:
	helm repo add appscode https://charts.appscode.com/stable/
	helm repo update
	helm install kubed appscode/kubed \
  	--version v0.12.0 \
  	--namespace kube-system
.PHONY: install-kubed

install-cas:
	kubectl -n cert-manager apply -f https://github.com/jetstack/google-cas-issuer/releases/download/v0.5.2/google-cas-issuer-v0.5.2.yaml
.PHONY: install-cas

install-dep-helm: install-eck-chart install-olm install-cert-manager
.PHONY: install-dep-helm


# SSL related
#https://github.com/acmesh-official/acme.sh
issue-cert:
	acme.sh --issue -d $(DOMAIN_NAME) -d "www.$(DOMAIN_NAME)" -d "kibana.$(DOMAIN_NAME)" -w $(pwd)/certs/$(DOMAIN_NAME)
.phony: issue-cert

gcp-auth:
	gcloud auth login
.PHONY: gcp-auth

gcp-login-cluster:
	gcloud container clusters --region $(CLUSTER_ZONE) get-credentials $(CLUSTER_NAME)
.PHONY: gcp-login-cluster

gcp-set-project:
	gcloud config set project $(PROJECT_ID)
.PHONY: gcp-set-project

# https://cert-manager.io/docs/configuration/acme/dns01/google/
gcp-service-account:
	gcloud iam service-accounts create $(DNS_SOLVER)
.PHONY: gcp-service-account

gcp-create-key-svc-account:
	gcloud iam service-accounts keys create $(CHART_FOLDER)/subcharts/templates/uploader-app/key.json \
   --iam-account $(DNS_SOLVER)@$(PROJECT_ID).iam.gserviceaccount.com
.PHONY: gcp-create-key-svc-account

