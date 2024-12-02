# Get current AWS account ID
data "aws_caller_identity" "current" {}

# KMS Key for EBS Encryption
resource "aws_kms_key" "ebs_encryption_key" {
  description             = "KMS key for EBS volume encryption"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  # Ensure the key is created and becomes active
  is_enabled = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow service-linked role use of the customer managed key"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
          ]
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "ebs-encryption-key"
  }
}

# KMS Key Alias with unique suffix
resource "aws_kms_alias" "ebs_encryption_key_alias" {
  name          = "alias/ebs-encryption-key"
  target_key_id = aws_kms_key.ebs_encryption_key.key_id
}

# KMS Key for RDS
resource "aws_kms_key" "rds_key" {
  description             = "KMS Key for RDS Encryption"
  enable_key_rotation     = true
  rotation_period_in_days = 90
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/rds-encryption-key"
  target_key_id = aws_kms_key.rds_key.key_id
}

# KMS Key for S3 Buckets
resource "aws_kms_key" "s3_key" {
  description             = "KMS Key for S3 Bucket Encryption"
  enable_key_rotation     = true
  rotation_period_in_days = 90
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/s3-encryption-key"
  target_key_id = aws_kms_key.s3_key.key_id
}
