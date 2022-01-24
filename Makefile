.ONESHELL
.PHONY: all plan apply destroy

# Check for necessary tools
ifeq (, $(shell which aws))
	$(error "No aws in $(PATH), go to https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html, pick your OS, and follow the instructions")
endif
ifeq (, $(shell which terraform))
	$(error "No terraform in $(PATH), get it from https://www.terraform.io/downloads.html")
endif

ifndef AWS_PROFILE
	$(error AWS_PROFILE is not defined. Set AWS profile as default.)
	export AWS_PROFILE=default
endif
ifndef AWS_REGION
	$(error AWS_REGION is not defined. Set AWS region to us-east-1.)
	export AWS_REGION=us-east-1
endif

local-init:
	cd infra/dev
	AWS_PROFILE=${AWS_PROFILE} terraform init

remote-init:
	cd infra/dev
	AWS_PROFILE=${AWS_PROFILE} terraform init

plan:
	cd infra/dev
	AWS_PROFILE=${AWS_PROFILE} terraform plan

validate:
	cd infra/dev
	terraform validate

apply:
	cd infra/dev
	AWS_PROFILE=${AWS_PROFILE} terraform apply

destroy:
	cd infra/dev
	AWS_PROFILE=${AWS_PROFILE} terraform destroy
