output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "vpc_default_security_group_id" {
  value = aws_vpc.this.default_security_group_id
}

output "vpc_default_network_acl_id" {
  value = aws_vpc.this.default_network_acl_id
}

output "vpc_default_route_table_id" {
  value = aws_vpc.this.default_route_table_id
}

output "vpc_name" {
  value = aws_vpc.this.tags.Name
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if length(regexall("public", s.tags.Name)) > 0]
}

output "restricted_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if length(regexall("restricted", s.tags.Name)) > 0]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if length(regexall("private", s.tags.Name)) > 0]
}

output "all_subnet_ids" {
  value = aws_subnet.this[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "restrict_route_table_id" {
  value = aws_route_table.restrict.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "public_route_table_association_ids" {
  value = aws_route_table_association.public[*].id
}

output "restrict_route_table_association_ids" {
  value = aws_route_table_association.restrict[*].id
}

output "private_route_table_association_ids" {
  value = aws_route_table_association.private[*].id
}

