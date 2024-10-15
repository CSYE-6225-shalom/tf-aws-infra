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
  description = "Owner ID for AMI"
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

variable "profile" {
  description = "The AWS profile to use. (NEU)"
  type        = string
}
