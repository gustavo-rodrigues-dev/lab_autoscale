resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
    tags = merge(
        {
        Name = "${var.service_name}-vpc"
        },
        var.common_tags
    )
}