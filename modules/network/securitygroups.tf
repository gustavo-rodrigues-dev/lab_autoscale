resource "aws_security_group" "public" {
    name       = "${var.service_name}-public-sg"
    vpc_id     = aws_vpc.this.id
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
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
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
    name       = "${var.service_name}-private-sg"
    vpc_id     = aws_vpc.this.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.public.id]
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.this.cidr_block]
    }

    tags = merge(
      {
        Name = "${var.service_name}-private-sg"
      },
      var.common_tags
    )
}
    

        