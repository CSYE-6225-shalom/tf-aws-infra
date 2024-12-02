# Get current AWS account ID
data "aws_caller_identity" "current" {}


# KMS Key for EC2 EBS Volume Encryption
resource "aws_kms_key" "ec2_key" {
  description             = "KMS key for EC2 EBS volume encryption"
  enable_key_rotation     = true
  rotation_period_in_days = 90

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : [
      {
        "Sid" : "EnableIAMUserPermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowAutoScalingServiceLinkedRoleUseOfKMSKey",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowAutoScalingServiceLinkedRoleCreateGrant",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action" : "kms:CreateGrant",
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}

# IAM Policy for EC2 Instances to Use the KMS Key
resource "aws_iam_policy" "ec2_kms_policy" {
  name        = "EC2KMSPolicy"
  description = "Policy for EC2 instances to use KMS key for EBS encryption"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowEC2InstancesToUseTheKMSKey",
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.ec2_key.arn
      }
    ]
  })
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
