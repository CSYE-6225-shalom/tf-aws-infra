resource "aws_security_group" "db_sg" {
  name        = "${var.environment}-database-security-group"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.application_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-database-security-group"
  }
}

resource "aws_db_parameter_group" "custom" {
  name   = "${var.environment}-custom-db-parameter-group"
  family = var.db_parameter_group_family

  tags = {
    Name = "${var.environment}-custom-db-parameter-group"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "${var.environment}-private-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name        = "${var.environment}-private-db-subnet-group"
    Environment = var.environment
  }
}

# Generate RDS db password using Random module in tf
resource "random_password" "rds_password" {
  length      = 24
  special     = false
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
}

# Generate a unique suffix to ensure secret name uniqueness
resource "random_id" "secret_suffix" {
  byte_length = 4
}

resource "aws_kms_key" "custom_kms_key" {
  description              = "KMS key for encrypting RDS password in Secrets Manager"
  enable_key_rotation      = true
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
}

resource "aws_kms_alias" "custom_kms_key_alias" {
  name          = "alias/custom-kms-key"
  target_key_id = aws_kms_key.custom_kms_key.id
}

resource "aws_secretsmanager_secret" "rds_db_secret" {
  name        = "rds-db-instance-password-${random_id.secret_suffix.hex}"
  description = "RDS database password"
  kms_key_id  = aws_kms_key.custom_kms_key.arn
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_db_secret.id
  secret_string = jsonencode({
    password = random_password.rds_password.result
  })
}

resource "aws_db_instance" "csye6225-pg" {
  identifier              = var.db_identifier
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = 5
  storage_type            = "gp2"
  multi_az                = false
  db_name                 = var.db_name
  username                = var.db_username
  password                = random_password.rds_password.result
  parameter_group_name    = aws_db_parameter_group.custom.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.private.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  # Add encryption configuration
  storage_encrypted = true
  kms_key_id        = var.rds_kms_key_id

  tags = {
    Name = "${var.environment}-postgres-rds-csye6225"
  }
}
