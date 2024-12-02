resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-application-security-group"
  vpc_id      = var.vpc_id
  description = "Application Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TCP traffic on ports 22 from anywhere in the world"
  }

  # Allow application port access only from ALB
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
    description     = "Allow application port access only from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows all outbound traffic (all ports, all protocols) to any IP address in the world"
  }

  tags = {
    Name        = "${var.environment}-application-security-group"
    Environment = var.environment
  }
}

resource "aws_launch_template" "csye6225_asg" {
  name = "csye6225_asg"

  image_id      = local.latest_ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<EOF
#!/bin/bash
####################################################
# CONFIGURE DB ENV VARIABLES FOR WEBAPP            #
####################################################
echo "Configuring application with RDS settings..."

SECRET_NAME="${var.aws_secretsmanager_secret_name}"
REGION="${var.region}"

# Install AWS CLI (if not already installed)
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# Retrieve the RDS password from Secrets Manager
DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id $SECRET_NAME \
  --region $REGION \
  --query SecretString \
  --output text | jq -r '.password')

cd /opt/webapp

# Create or update the .env file
cat <<EOT > /opt/webapp/.env
RDS_HOSTNAME="${var.db_host}"
RDS_PORT=${var.db_port}
RDS_DB_NAME="${var.db_name}"
RDS_USERNAME="${var.db_username}"
RDS_PASSWORD="$DB_PASSWORD"
AWS_S3_BUCKET="${var.s3_bucket_name}"
AWS_REGION="${var.region}"
PORT=${var.app_port}
AWS_SNS_TOPIC_ARN=${local.sns_topic_arn}
VERIFICATION_URL="${var.domain_name}/v1/verify-email"
EOT

echo "RDS configuration complete."

##############################################################
# CONFIGURE CLOUDWATCH AGENT TO USE CONFIG FILE AND RE-START #
##############################################################
echo "Configuring Cloudwatch Agent..."

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/cloudwatch-config.json \
    -s

echo "Cloudwatch Agent configuration complete."
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-app-instance"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = "${var.environment}-asg"
  desired_capacity          = 4
  max_size                  = 6
  min_size                  = 4
  health_check_type         = "ELB"
  health_check_grace_period = 300
  default_cooldown          = 60

  target_group_arns   = [var.webapp_lb_target_group_arn]
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.csye6225_asg.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-app-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "auto-scale-group-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# CloudWatch Alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_high" {
  alarm_name          = "ec2-cpu-usage-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "6"
  alarm_description   = "This metric monitors EC2 CPU utilization above 5%"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}

# Scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "auto-scale-group-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# CloudWatch Alarm for low CPU usage
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_low" {
  alarm_name          = "cpu-usage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5.7"
  alarm_description   = "This metric monitors EC2 CPU utilization below 3%"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}
