module "vpc" {
  source = "./modules/vpc"

  region      = var.region
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  public_route_cidr = var.public_route_cidr
  public_subnet_count = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}
