variable "iam_role_name" {
  description = "Name of the IAM role for the CloudWatch Agent & S3"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}
