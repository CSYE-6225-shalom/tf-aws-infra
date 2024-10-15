module "vpc" {
  source = "./modules/vpc"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_route_cidr    = var.public_route_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id                      = module.vpc.vpc_id
  app_port                    = var.app_port
  instance_type               = var.instance_type
  ec2_volume_size             = var.ec2_volume_size
  ec2_volume_type             = var.ec2_volume_type
  ec2_delete_on_termination   = var.ec2_delete_on_termination
  ec2_disable_api_termination = var.ec2_disable_api_termination
  ami_owner_id                = var.ami_owner_id
  ec2_instance_count          = var.ec2_instance_count
  environment                 = var.environment
  depends_on                  = [module.vpc]
}
