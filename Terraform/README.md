# Terraform
#

### Notes
- While tools like ansible, puppet, or chef automates mostly OS related tasks, Terraform is able to automate the infrastructure itself
- Has its own DSL similar to JSON


### Basic Commands
- terraform init - creates base file
- terraform validate - checks syntax
- terraform fmt - reformats to readable
- terraform plan - shows you what will happen if you execute
- terraform apply
- terraform destroy

### Variables
- defining variables to move secrets to a separate file
- define variables for values that change
- define variables to reuse code

### Provisioning
- Build custom images with tools like packer
- can use standard image and use provisioners to setup softwares and files
	- can upload files/artifacts
	- remote_exec
		- to execute tasks remotely
	- can use provisioners like ansible, puppet or chef