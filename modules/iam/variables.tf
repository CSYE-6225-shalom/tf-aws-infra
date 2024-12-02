variable "environment" {
  description = "Environment name"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM role for the CloudWatch Agent & S3"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "aws_secretsmanager_secret_arn" {
  description = "Secrets Manager ARN"
  type        = string
}

variable "rds_kms_key_arn" {
  description = "RDS DB password kms key ARN"
  type        = string
}
