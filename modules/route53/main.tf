# Data source for existing Route 53 zone
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# Create A records for all instances with environment prefix
resource "aws_route53_record" "ec2_instance_ip" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "60"
  records = var.ec2_instances_public_ips
}
