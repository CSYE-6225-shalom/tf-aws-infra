variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_kms_key_id" {
  description = "The KMS key for encrypting the S3 bucket"
  type        = string
}
