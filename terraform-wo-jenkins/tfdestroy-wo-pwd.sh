#!/bin/bash

# Plan and deploy
terraform plan -destroy -var 'nsx_username=admin' -var 'avi_username=admin'  -out=tfdestroy
terraform apply -auto-approve tfdestroy


