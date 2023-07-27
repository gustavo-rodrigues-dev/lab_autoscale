locals {
  public_subnets     = [for s in aws_subnet.this : s if length(regexall("public", s.tags.Name)) > 0]
  private_subnets    = [for s in aws_subnet.this : s if length(regexall("private", s.tags.Name)) > 0]
  restricted_subnets = [for s in aws_subnet.this : s if length(regexall("restricted", s.tags.Name)) > 0]
  nat_gateways       = [for ng in aws_nat_gateway.this : ng]
}