SHELL:=/bin/bash
include .env

VERSION=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test diagram docs format release

all: test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init -upgrade && $(TERRAFORM) validate && \
		$(TERRAFORM) -chdir=modules/linkerd init -upgrade && $(TERRAFORM) -chdir=modules/linkerd validate && \
		$(TERRAFORM) -chdir=modules/gatekeeper init -upgrade && $(TERRAFORM) -chdir=modules/gatekeeper validate

test: validate
	$(CHECKOV) -d /work
	$(TFSEC) /work

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

release: test
	git tag $(VERSION) && git push --tags
