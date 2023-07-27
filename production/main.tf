module "network" {
  source             = "../modules/network"
  service_name       = var.service_name
  common_tags        = var.common_tags
  subnet_cidr_blocks = var.subnet_cidr_blocks
}