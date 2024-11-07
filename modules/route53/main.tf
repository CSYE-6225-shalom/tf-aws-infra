# Data source for existing Route 53 zone
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# Data source for existing ALB
data "aws_lb" "webapp-load-balancer" {
  name = var.webapp_alb_name
}

# Create A records for all instances with environment prefix
resource "aws_route53_record" "ec2_instance_ip" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.webapp-load-balancer.dns_name
    zone_id                = data.aws_lb.webapp-load-balancer.zone_id
    evaluate_target_health = true
  }
}
