resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.service_name}-igw"
    },
    var.common_tags
  )
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.service_name}-rtb"
    },
    var.common_tags
  )
}
