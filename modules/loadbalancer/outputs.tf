output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.lb_sg.id
}

output "webapp_lb_target_group_arn" {
  description = "The ARN of the target group for the web application load balancer"
  value       = aws_lb_target_group.webapp_lb.arn
}

output "webapp_alb_name" {
  value = aws_lb.webapp_lb.name
}
