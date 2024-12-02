# KMS Key for EC2
resource "aws_kms_key" "ec2_key" {
  description             = "KMS Key for EC2 Encryption"
  enable_key_rotation     = true
  rotation_period_in_days = 90
}

resource "aws_kms_alias" "ec2_key_alias" {
  name          = "alias/ec2-encryption-key"
  target_key_id = aws_kms_key.ec2_key.key_id
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
