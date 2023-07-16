output "vpc_id" {
  value = aws_vpc.this.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if length(regexall("public", s.tags.Name)) > 0]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.this : s.id if length(regexall("private", s.tags.Name)) > 0]
}

output "all_subnet_ids" {
  value = aws_subnet.this[*].id
}