output "ebs_encryption_key" {
  value = aws_kms_key.ebs_encryption_key.id
}

output "rds_kms_key_id" {
  value = aws_kms_key.rds_key.arn
}

output "s3_kms_key_id" {
  value = aws_kms_key.s3_key.arn
}
