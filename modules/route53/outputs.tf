output "domain_name" {
  value = aws_route53_record.ec2_instance_ip.name
}
