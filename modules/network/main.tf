#####################
# VPC
#####################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(
    {
      Name = "${var.service_name}-vpc"
    },
    var.common_tags
  )
}

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
# Subnets
#####################
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

#####################
# Internet Gateway
#####################

resource "aws_eip" "igw" {
  tags = merge(
    {
      Name = "${var.service_name}-igw-eip"
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

#####################
# Security Groups
#####################
resource "aws_security_group" "public" {
  name   = "${var.service_name}-public-sg"
  vpc_id = aws_vpc.this.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.private_subnets.*.cidr_block
  }

  tags = merge(
    {
      Name = "${var.service_name}-public-sg"
    },
    var.common_tags
  )
}

resource "aws_security_group" "private" {
  name   = "${var.service_name}-private-sg"
  vpc_id = aws_vpc.this.id
  ingress {
    from_port       = 22 ## SSH
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  tags = merge(
    {
      Name = "${var.service_name}-private-sg"
    },
    var.common_tags
  )
}

resource "aws_security_group" "restricted" {
  name   = "${var.service_name}-restricted-sg"
  vpc_id = aws_vpc.this.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.restricted_subnets.*.cidr_block
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  tags = merge(
    {
      Name = "${var.service_name}-restricted-sg"
    },
    var.common_tags
  )
}

#####################
# Route Tables
#####################
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

resource "aws_route_table" "restrict" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.service_name}-restrict-rtb"
    },
    var.common_tags
  )
}

#####################
# Route Table Associations
#####################
resource "aws_route_table_association" "public" {
  count          = length(local.public_subnets)
  subnet_id      = local.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnets)
  subnet_id      = local.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "restrict" {
  count          = length(local.restricted_subnets)
  subnet_id      = local.restricted_subnets[count.index].id
  route_table_id = aws_route_table.restrict.id
}

#####################
# route table routes
#####################

resource "aws_route" "restrict" {
  count                  = length(local.restricted_subnets)
  route_table_id         = aws_route_table.restrict.id
  destination_cidr_block = local.restricted_subnets[count.index].cidr_block
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route" "public" {
  count                  = length(local.public_subnets)
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}