output "role_name" {
  description = "Name of the created IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "instance_profile_name" {
  description = "Name of the instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "instance_profile_arn" {
  description = "ARN of the instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}