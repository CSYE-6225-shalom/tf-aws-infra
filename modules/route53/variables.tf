variable "domain_name" {
  type        = string
  description = "App domain name (Namecheap)"
}

variable "webapp_alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
