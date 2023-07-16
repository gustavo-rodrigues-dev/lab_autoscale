resource "aws_subnet" "this" {
  count             = length(var.subnet_cidr_blocks)
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
