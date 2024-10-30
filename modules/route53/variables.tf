variable "domain_name" {
  type        = string
  description = "App domain name (Namecheap)"
}

variable "app_port" {
  type        = number
  description = "Port number for your application"
}

variable "ec2_instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
}

variable "ec2_instances_public_ips" {
  type        = list(string)
  description = "List of public IPs of the EC2 instances"
}

variable "environment" {
  description = "Environment name"
  type        = string
}
