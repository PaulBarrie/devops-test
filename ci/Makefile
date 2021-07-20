# set default shell
SHELL := /bin/bash
.SHELLFLAGS = -c

NAMESPACE=dreamquark-ai
VCS_PROVIDER=github
ORG_NAME=dreamquark-ai
ORB_NAME=ci-security-report
ORB_FILE=./orbs/orb.yml
ORB_DIR=./orbs
VERSION=dev:1.0.0


IMAGE=test
BASE_IMAGE=alpine
BASE_TAG=helm

TAG=latest
DOCKERFILE=docker/Dockerfile
BUILD_CTX=docker
INTERACTIVE=-ti

build-docker:
	docker build -t $(IMAGE):$(TAG) --build-arg BASE_TAG=$(BASE_TAG)\
	--build-arg BASE_IMAGE=$(BASE_IMAGE) -f $(DOCKERFILE) $(BUILD_CTX)
.PHONY: build-docker

debug-docker:
	docker run -ti $(IMAGE):$(TAG) 
.PHONY: run-docker

run-docker:
	docker run $(IMAGE):$(TAG) $(CMD)
.PHONY: run-docker

pack-orb:
	circleci orb pack $(ORB_DIR) > $(ORB_FILE)
.PHONY: pack-orb

validate-orb:
	circleci orb validate $(ORB_FILE)
.PHONY: validate-orb

publish-orb:
	circleci orb publish $(ORB_FILE) $(NAMESPACE)/$(ORB_NAME)@$(VERSION)
.PHONY: publish-orb

all: pack-orb validate-orb publish-orb clear
.PHONY: all

clear:
	rm -f $(ORB_FILE)
.PHONY: clear