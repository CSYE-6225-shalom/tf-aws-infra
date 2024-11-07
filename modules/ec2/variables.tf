variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "ami_owner_id" {
  description = "AMI Owner ID"
  type        = string
}

variable "ec2_instance_count" {
  description = "Number of Ec2 instances to deploy"
  type        = number
}

variable "ec2_volume_size" {
  description = "Volume size of the Ec2 machine"
  type        = number
}

variable "ec2_volume_type" {
  description = "Volume type of the Ec2 machine"
  type        = string
}

variable "ec2_delete_on_termination" {
  description = "Delete the Ec2 instance volume when instance is deleted"
  type        = bool
}

variable "ec2_disable_api_termination" {
  description = "Prevent the instance from being terminated through the AWS Management Console, CLI, or API"
  type        = bool
}

variable "db_username" {
  description = "The Username for db"
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The database name to use"
  type        = string
}

variable "db_port" {
  description = "The port for the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "db_host" {
  description = "The Host endpoint for the RDS PostgreSQL database"
  type        = string
}

variable "rds_instance_id" {
  description = "The ID of the RDS instance this EC2 instance depends on"
  type        = string
}

variable "alb_security_group_id" {
  description = "The security group ID of the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "webapp_lb_target_group_arn" {
  description = "The ARN of the AWS Load Balancer target group"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM role attached to this EC2 instance to connect to Cloudwatch"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name used for webapp to push images to"
  type        = string
}

variable "region" {
  description = "AWS region in which resources are deployed"
  type        = string
}