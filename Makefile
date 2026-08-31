.PHONY: fmt validate plan-dev plan-prod

fmt:
	terraform fmt -recursive

validate:
	./scripts/validate.sh

plan-dev:
	terraform -chdir=envs/dev init
	terraform -chdir=envs/dev plan

plan-prod:
	terraform -chdir=envs/prod init
	terraform -chdir=envs/prod plan
