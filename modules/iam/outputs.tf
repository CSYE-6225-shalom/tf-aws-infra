output "cloudwatch_agent_role_name" {
  description = "Name of the IAM role created for the CloudWatch Agent"
  value       = var.cloudwatch_agent_role_name
}

output "cloudwatch_agent_instance_profile" {
  description = "Name of the IAM instance profile created for the CloudWatch Agent"
  value       = aws_iam_instance_profile.cloudwatch_agent_instance_profile.name
}
