output "database_security_group_id" {
  value = aws_security_group.db_sg.id
}

output "db_parameter_group_name" {
  value = aws_db_parameter_group.custom.name
}

output "rds_host_endpoint" {
  value = split(":", aws_db_instance.csye6225-pg.endpoint)[0]
}

output "rds_instance_id" {
  value = aws_db_instance.csye6225-pg.id
}

output "rds_instance_id_arn" {
  value = aws_db_instance.csye6225-pg.arn
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.private.name
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "rds_secret_manager_arn" {
  value = aws_secretsmanager_secret.rds_db_secret.arn
}

output "rds_kms_key_arn" {
  value = aws_kms_key.custom_kms_key.arn
}

output "aws_secretsmanager_secret_name" {
  value = aws_secretsmanager_secret.rds_db_secret.name
}
