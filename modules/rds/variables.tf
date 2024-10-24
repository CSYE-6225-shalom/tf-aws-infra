variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "db_port" {
  description = "The port for the PostgreSQL database"
  type        = number
  default     = 5432
}

variable "application_security_group_id" {
  description = "The ID of the application security group"
  type        = string
}

variable "db_parameter_group_family" {
  description = "PostgreSQL family for the DB parameter group"
  type        = string
}

variable "db_identifier" {
  description = "The database identifier name to use"
  type        = string
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

variable "environment" {
  description = "Environment name"
  type        = string
}
