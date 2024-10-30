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

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TCP traffic on ports 80 from anywhere in the world"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TCP traffic on ports 443 from anywhere in the world"
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TCP traffic on Application ports from anywhere in the world"
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

resource "aws_instance" "app_instance" {
  count                  = var.ec2_instance_count
  ami                    = local.latest_ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = tolist(local.public_subnet_ids)[count.index]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  root_block_device {
    volume_size           = var.ec2_volume_size
    volume_type           = var.ec2_volume_type
    delete_on_termination = var.ec2_delete_on_termination
  }

  disable_api_termination = var.ec2_disable_api_termination

  user_data = base64encode(<<EOF
#!/bin/bash
####################################################
# CONFIGURE DB ENV VARIABLES FOR WEBAPP            #
####################################################
echo "Configuring application with RDS settings..."

cd /opt/webapp
# Create or update the .env file
cat <<EOT > /opt/webapp/.env
RDS_HOSTNAME="${var.db_host}"
RDS_PORT=${var.db_port}
RDS_DB_NAME="${var.db_name}"
RDS_USERNAME="${var.db_username}"
RDS_PASSWORD="${var.db_password}"
AWS_S3_BUCKET="${var.s3_bucket_name}"
AWS_REGION="${var.region}"
PORT=${var.app_port}
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

  tags = {
    Name        = "${var.environment}-app-instance-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [var.rds_instance_id]
}
