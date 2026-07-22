output "endpoint" {
  description = "Універсальний ендпоінт для підключення до БД (RDS або Aurora Cluster)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].endpoint
}

output "reader_endpoint" {
  description = "Reader ендпоінт (тільки для Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "db_name" {
  description = "Назва бази даних"
  value       = var.db_name
}

output "security_group_id" {
  description = "ID створеної Security Group"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "Назва створеної DB Subnet Group"
  value       = aws_db_subnet_group.default.name
}