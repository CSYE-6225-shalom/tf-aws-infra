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
