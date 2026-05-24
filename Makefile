.PHONY: all init plan apply destroy clean

all: init plan

init:
	terraform init -upgrade

plan:
	terraform plan

apply:
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve

clean:
	rm -rf .terraform
