resource "random_uuid" "bucket_name" {}

resource "aws_s3_bucket" "webapp_s3_bucket" {
  bucket        = random_uuid.bucket_name.result
  force_destroy = true # Allows Terraform to delete non-empty bucket
  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "webapp_s3_bucket" {
  bucket = aws_s3_bucket.webapp_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "webapp_s3_bucket" {
  bucket = aws_s3_bucket.webapp_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.s3_kms_key_id
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.webapp_s3_bucket.id

  rule {
    id     = "transition-to-ia-rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
