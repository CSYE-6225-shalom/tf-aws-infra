variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_route_cidr" {
  description = "CIDR block for the public route"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "ami_owner_id" {
  description = "AMI Owner ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
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

variable "ec2_instance_count" {
  description = "Number of Ec2 instances to deploy"
  type        = number
}

variable "db_parameter_group_family" {
  description = "PostgreSQL family for the DB parameter group"
  type        = string
}

variable "db_port" {
  description = "The port for the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "db_identifier" {
  description = "The database identifier name to use"
  type        = string
}

variable "db_username" {
  description = "The Username for db"
  type        = string
}

variable "db_name" {
  description = "The database name to use"
  type        = string
}

variable "db_engine" {
  description = "The database engine to use"
  type        = string
}

variable "db_engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role for the CloudWatch Agent & S3"
  type        = string
  default     = "webapp-iam-role"
}

variable "profile" {
  description = "The AWS profile to use. (NEU)"
  type        = string
}

variable "webapp_domain_name" {
  description = "Te domain name for the webapp. (Namecheap DNS)"
  type        = string
}
