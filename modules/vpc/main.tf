data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc-${data.aws_caller_identity.current.account_id}-${random_string.suffix.result}-tf"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw-${data.aws_caller_identity.current.account_id}-${random_string.suffix.result}-tf"
    Environment = var.environment
  }
}
}