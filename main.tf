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
  db_host                     = module.rds.rds_host_endpoint
  db_port                     = var.db_port
  db_name                     = var.db_name
  db_username                 = var.db_username
  db_password                 = var.db_password
  rds_instance_id             = module.rds.rds_instance_id
  iam_instance_profile        = module.iam.instance_profile_name
  environment                 = var.environment
  region                      = var.region
  s3_bucket_name              = module.s3.bucket_name
  alb_security_group_id       = module.loadbalancer.alb_security_group_id
  public_subnet_ids           = module.vpc.public_subnet_ids
  webapp_lb_target_group_arn  = module.loadbalancer.webapp_lb_target_group_arn
  domain_name                 = var.webapp_domain_name
  depends_on                  = [module.vpc]
}

module "rds" {
  source = "./modules/rds"

  vpc_id                        = module.vpc.vpc_id
  application_security_group_id = module.ec2.application_security_group_id
  db_port                       = var.db_port
  db_parameter_group_family     = var.db_parameter_group_family
  db_identifier                 = var.db_identifier
  db_name                       = var.db_name
  db_username                   = var.db_username
  db_password                   = var.db_password
  db_engine                     = var.db_engine
  db_engine_version             = var.db_engine_version
  db_instance_class             = var.db_instance_class
  environment                   = var.environment
  depends_on                    = [module.vpc]
}

module "iam" {
  source = "./modules/iam"

  environment   = var.environment
  iam_role_name = var.role_name
  s3_bucket_arn = module.s3.bucket_arn
}

module "s3" {
  source = "./modules/s3"

  environment = var.environment
}

module "route53" {
  source = "./modules/route53"

  domain_name     = var.webapp_domain_name
  webapp_alb_name = module.loadbalancer.webapp_alb_name
  environment     = var.environment
  depends_on      = [module.loadbalancer]
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_port          = var.app_port
  environment       = var.environment
}
