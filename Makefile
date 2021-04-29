# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
.PHONY: docs help test

# Use bash for inline if-statements in arch_patch target
SHELL:=bash
ARCH:=$(shell uname -m)
OWNER:=$(IMGOWNER)
REGISTRY:=$(REG)

ifeq ($(BASEIMAGE),pytorch)
BASE=nvcr.io/nvidia/pytorch:21.04-py3
TAG=cuda-pytorch
FILE=Dockerfile
else ifeq ($(BASEIMAGE),pytorchlightning)
BASE=nvcr.io/nvidia/pytorch:21.04-py3
TAG=cuda-pytorchlightning
FILE=Dockerfile_lightning
else
BASE=nvcr.io/nvidia/tensorflow:21.04-tf2-py3
TAG=cuda-tf
FILE=Dockerfile_tf
endif

WEBDAVIMAGE=alpine-webdav
NONE_JUPYTER_IMAGES="alpine-webdav hostpath-provisioner "

# Need to list the images in build dependency order
ALL_STACKS:=base-notebook \
	minimal-notebook \
	scipy-notebook \
	alpine-webdav \
	hostpath-provisioner

ALL_IMAGES:=$(ALL_STACKS)

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo "aist/docker-stacks"
	@echo "====================="
	@echo "Replace % with a stack directory name (e.g., make build/minimal-notebook)"
	@echo
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build/%: DARGS?=
build/%: ## build the latest image for a stack
	@if [[ $(NONE_JUPYTER_IMAGES) =~ (^|[[:space:]])$(notdir $@)($|[[:space:]]) ]]; then \
	echo ;\
	echo "Building: $(OWNER)/$(notdir $@):latest" ;\
	cd ./$(notdir $@) && docker build $(DARGS) --rm --force-rm -t $(OWNER)/$(notdir $@):latest -f Dockerfile . ;\
	docker tag $(OWNER)/$(notdir $@):latest $(REGISTRY)/$(OWNER)/$(notdir $@):latest ;\
	else \
	echo ;\
	echo "Building: $(OWNER)/$(notdir $@)-$(TAG):latest" ;\
	cd ./$(notdir $@) && docker build --build-arg ROOT_CONTAINER=$(BASE) --build-arg OWNER=$(OWNER) $(DARGS) --rm --force-rm -t $(OWNER)/$(notdir $@)-$(TAG):latest -f $(FILE) . ;\
	docker image inspect $(OWNER)/$(notdir $@)-$(TAG):latest | grep CUDA_VERSION ;\
	echo ;\
	echo -n "Built image size: " ;\
	docker images $(OWNER)/$(notdir $@)-$(TAG):latest --format "{{.Size}}" ;\
	docker tag $(OWNER)/$(notdir $@)-$(TAG):latest $(REGISTRY)/$(OWNER)/$(notdir $@)-$(TAG):latest ;\
	fi;

build-all: $(foreach I,$(ALL_IMAGES),build/$(I) ) ## build all stacks

pull-base: ## pull a jupyter image
	@docker pull $(BASE)

img-rm:  ## remove jupyter images
	@echo "Removing $(OWNER) images ..."
	-docker rmi --force $(shell docker images --quiet "$(OWNER)/*") 2> /dev/null
	-docker rmi --force $(shell docker images --quiet "$(REGISTRY)/$(OWNER)/*") 2> /dev/null
	-docker rmi --force $(shell docker images -f "dangling=true" -q) 2> /dev/null


push/%: DARGS?=
push/%: ## push all tags for a jupyter image
	@if [[ $(NONE_JUPYTER_IMAGES) =~ (^|[[:space:]])$(notdir $@)($|[[:space:]]) ]]; then \
	docker push $(DARGS) $(REGISTRY)/$(OWNER)/$(notdir $@) ;\
	else \
	docker push $(DARGS) $(REGISTRY)/$(OWNER)/$(notdir $@)-$(TAG) ;\
	fi;


push-all: $(foreach I,$(ALL_IMAGES),push/$(I) ) ## push all tagged images
