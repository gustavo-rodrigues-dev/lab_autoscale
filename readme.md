# Simple application IAC
This is a simple application to demonstrate the use of Terraform.

## Requirements
- Terraform
- AWS CLI
- AWS Account
- Git
- Go
- Terratest

## Modules
- VPC
- RDS
- ECS
- CloudWatch

## Structure
```
├── README.md
├── {environment}
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── provider.tf
├── modules
│   ├── network
│   ├─- application
│   └── database
├─- test
│   ├── modules
│   │   ├── network
│   │   ├─- application
│   │   └── database
│   └── {environment}
```
