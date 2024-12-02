# Combined IAM Role for CloudWatch and S3 access
resource "aws_iam_role" "ec2_role" {
  name = var.iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach CloudWatch Agent Policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ec2_role.name
}

# Create custom S3 policy
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Limited S3 access policy for ec2 instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Attach the custom policy to the role
resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# Create a custom SNS policy for limited access
resource "aws_iam_policy" "sns_publish_policy" {
  name        = "SNSPublishPolicy"
  description = "Policy for publishing messages to a specific SNS topic. Avoiding SNSFullAccess policy."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sns:Publish",
        Resource = "${local.sns_topic_arn}"
      }
    ]
  })
}

# Attach the custom SNS policy to the role
resource "aws_iam_role_policy_attachment" "sns_publish_policy_attachment" {
  policy_arn = aws_iam_policy.sns_publish_policy.arn
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_policy" "ec2_secrets_access" {
  name        = "RDSDBPasswordAccess"
  description = "Policy for accessing RDS db password stored in Secrets Manager."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.aws_secretsmanager_secret_arn
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ],
        Resource = var.rds_kms_key_arn
      }
    ]
  })
}

# Attach the custom Secrets Manager policy to the role
resource "aws_iam_role_policy_attachment" "secrets_manager_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_secrets_access.arn
  role       = aws_iam_role.ec2_role.name
}

# Combined Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.iam_role_name}-profile"
  role = aws_iam_role.ec2_role.name
}

