output "ec2_kms_key_id" {
  value = aws_kms_key.ec2_key.arn
}

output "rds_kms_key_id" {
  value = aws_kms_key.rds_key.arn
}

output "s3_kms_key_id" {
  value = aws_kms_key.s3_key.arn
}
