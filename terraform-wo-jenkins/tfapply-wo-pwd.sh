#!/bin/bash

# Initialise the configuration
terraform init -input=false

# Plan and deploy
terraform plan -var 'nsx_username=admin' -var 'avi_username=admin'  -out=tfplan
terraform apply -auto-approve tfplan


