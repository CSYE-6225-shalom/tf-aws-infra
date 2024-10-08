module "vpc" {
  source = "./modules/vpc"

  region      = var.region
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}
