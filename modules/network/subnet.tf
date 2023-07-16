resource "aws_subnet" "this" {
#   for_each = {
#     "public_a" : [ "192.168.1.0/24", "${var.aws_region}a", "${var.service_name}-public-a" ]
#     "public_b" : [ "192.168.2.0/24", "${var.aws_region}b", "${var.service_name}-public-b" ]
#     "private_a" : [ "192.168.3.0/24", "${var.aws_region}a", "${var.service_name}-private-a" ]
#     "private_b" : [ "192.168.4.0/24", "${var.aws_region}b", "${var.service_name}-private-b" ]
#   }
    count = length(var.subnet_cidr_blocks)
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.subnet_cidr_blocks[count.index].cidr_block
    availability_zone = "${var.aws_region}${var.subnet_cidr_blocks[count.index].az}"
    tags = merge(
        {
        Name = "${var.service_name}-${var.subnet_cidr_blocks[count.index].name}"
        },
        var.common_tags
    )
}
