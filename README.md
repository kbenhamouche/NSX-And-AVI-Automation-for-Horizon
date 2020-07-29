# NSX-And-AVI-Automation-for-Horizon

NSX and AVI automation via Terraform (and Jenkins for CICD pipeline - optional) for VMware Horizon solution.

This example is for DEMO purpose ONLY. 
- it shows how to automate NSX Microsegmentation for VMware Horizon.
- and includes how to automate the AVI Virtual Services creation for VMware Horizon.

The root folder includes the Jenkins file to create a pipeline with Terraform.
Note: you have to configure the NSX Manager password and the AVI Controller password in the Jenkins Credentials section.

The "Terraform-wo-jenkins" folder provides all scripts to automate the NSX and AVI configuration.
Note: you have to provide the NSX Manager password and the AVI Controller password.
