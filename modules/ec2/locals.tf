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

# Data source to fetch SNS topic created in the same account.
data "aws_sns_topic" "sns_topic" {
  name = "csye6225-${var.environment}-sns"
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
  sns_topic_arn     = data.aws_sns_topic.sns_topic.arn
  latest_ami_id     = data.aws_ami.latest.id
}