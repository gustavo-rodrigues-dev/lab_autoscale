#####################
# Internet Gateway
#####################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.service_name}-igw"
    },
    var.common_tags
  )
}

#####################
# NAT Gateway
#####################

resource "aws_eip" "nat" {
  tags = merge(
    {
      Name = "${var.service_name}-nat-eip"
    },
    var.common_tags
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = local.restricted_subnets[0].id
  tags = merge(
    {
      Name = "${var.service_name}-nat"
    },
    var.common_tags
  )
}