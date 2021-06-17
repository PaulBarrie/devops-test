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