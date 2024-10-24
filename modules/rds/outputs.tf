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

output "db_subnet_group_name" {
  value = aws_db_subnet_group.private.name
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}
