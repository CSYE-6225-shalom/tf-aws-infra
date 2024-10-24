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
  password                = var.db_password
  parameter_group_name    = aws_db_parameter_group.custom.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.private.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "${var.environment}-postgres-rds-csye6225"
  }
}
