data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
  public_subnets     = [for i in range(3) : cidrsubnet(var.vpc_cidr, 4, i)]
  private_subnets    = [for i in range(3) : cidrsubnet(var.vpc_cidr, 4, i + 3)]
}
