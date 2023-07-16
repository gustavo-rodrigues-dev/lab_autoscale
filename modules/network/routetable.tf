## aassociate igw to public subnets filtering by tag Name contais public
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }
    tags = merge(
        {
            Name = "${var.service_name}-public-rtb"
        },
        var.common_tags
    )
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id
    tags = merge(
        {
            Name = "${var.service_name}-private-rtb"
        },
        var.common_tags
    )
}

resource "aws_route_table_association" "public" {
    count          = length(local.public_subnets)
    subnet_id      = local.public_subnets[count.index].id
    route_table_id = aws_route_table.public.id
}

# associate igw to public subnets filte

