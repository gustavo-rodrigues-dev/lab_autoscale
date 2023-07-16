variable "service_name" {
  type        = string
  description = "Name of the service"
  default     = "my-service"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}

variable "subnet_cidr_blocks" {
  type        = list(object({
    cidr_block        = string
    az = string
    name              = string
  }))
  description = "List of CIDR blocks for the subnets"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
  default     = {
    "Environment" = "production"
  }
}