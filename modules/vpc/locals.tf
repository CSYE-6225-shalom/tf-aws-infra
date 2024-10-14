data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
  public_subnets     = [for i in range(var.public_subnet_count) : cidrsubnet(var.vpc_cidr, 4, i)]
  private_subnets    = [for i in range(var.private_subnet_count) : cidrsubnet(var.vpc_cidr, 4, i + var.public_subnet_count)]
}
