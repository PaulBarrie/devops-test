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
default: help;   # default target

help: ## display commands help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

up: ## Start all components
	echo "Start all components"
	docker-compose up -d
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
ingress-controller: ##
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/baremetal/deploy.yaml
.PHONY: ingress-controller

apply-kube:
	kubectl apply -f ./kubernetes
.PHONY: apply-kube

clear-chart:
ifeq ($(helm list | grep $(CHART_NAME) | wc -l),1)
	@echo "Remove chart"
	helm uninstall $(CHART_NAME)  
endif
	rm -f $(CHART_FOLDER)/charts/* devops-test-0.1.0.tgz
.PHONY: clear-chart

package-chart:
	$(MAKE) clear-chart
	helm package --dependency-update $(CHART_FOLDER) 
.PHONY: package-chart
# Helm
install-chart: ## 
	$(MAKE) package-chart 
	helm install  $(CHART_NAME) $(CHART_FOLDER)
.PHONY: install-chart

helm-debug:
	$(MAKE) clear-clear
	$(MAKE) package-chart 
	helm install --dry-run --debug $(CHART_NAME) $(CHART_FOLDER) > logs
.PHONY: helm-debug

template-chart: ## helm template commands
	$(MAKE) clear-chart
	$(MAKE) package-chart
	helm template --debug $(CHART_NAME) devops-test-0.1.0.tgz > test.yaml
.PHONY: template

