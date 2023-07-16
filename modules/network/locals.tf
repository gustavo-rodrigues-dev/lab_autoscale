locals {
    public_subnets = [for s in aws_subnet.this : s if length(regexall("public", s.tags.Name)) > 0]
    private_subnets = [for s in aws_subnet.this : s if length(regexall("private", s.tags.Name)) > 0]
}