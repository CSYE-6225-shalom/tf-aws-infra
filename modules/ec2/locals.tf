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

# Define data source to fetch the latest AMI
data "aws_ami" "latest" {
  most_recent = true
  owners      = [var.ami_owner_id]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  public_subnet_ids = data.aws_subnets.public.ids
  latest_ami_id     = data.aws_ami.latest.id
}