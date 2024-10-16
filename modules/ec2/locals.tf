data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-public-subnet-*"]
  }
}

locals {
  public_subnet_ids = data.aws_subnets.public.ids
}
