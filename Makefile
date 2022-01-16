SHELL:=/bin/bash
include .env

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/linkerd && $(TERRAFORM) validate modules/linkerd && \
		$(TERRAFORM) init modules/gatekeeper && $(TERRAFORM) validate modules/gatekeeper

test: validate
	$(CHECKOV) -d /work && \
		$(CHECKOV) -d /work/modules/linkerd && \
		$(CHECKOV) -d /work/modules/gatekeeper

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ >./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/linkerd >./modules/linkerd/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/gatekeeper >./modules/gatekeeper/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/linkerd && \
		$(TERRAFORM) fmt -list=true ./modules/gatekeeper
