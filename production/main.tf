terraform {
    required_version = ">= 1.4.0"
    required_providers {
        aws = ">= 5.0.0"
    }
}

provider "aws" {
    region = var.aws_region
}

module "network" {
    source = "../modules/network"
    service_name = var.service_name
    common_tags = var.common_tags
    subnet_cidr_blocks = var.subnet_cidr_blocks
}