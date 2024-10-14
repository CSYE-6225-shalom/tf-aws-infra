output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = [for instance in aws_instance.app_instance : instance.id]
}

output "security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app_sg.id
}

output "latest_ami_id" {
  description = "The ID of the latest AMI retrieved from AWS"
  value       = local.latest_ami_id
}
