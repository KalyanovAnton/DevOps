output "s3_bucket_arn" {
  description = "ARN S3 бакета для терраформ стейту"
  value       = module.s3_backend.s3_bucket_arn
}

output "dynamodb_table_name" {
  description = "Назва DynamoDB таблиці для блокувань"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "Повна адреса ECR репозиторію"
  value       = module.ecr.repository_url
}


output "jenkins_release" {
  description = "Назва Helm-релізу Jenkins"
  value       = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  description = "Namespace, де розгорнутий Jenkins"
  value       = module.jenkins.jenkins_namespace
}


output "db_endpoint" {
  description = "Ендпоінт для підключення до бази даних"
  value       = module.rds.endpoint
}

output "db_reader_endpoint" {
  description = "Reader ендпоінт Aurora кластера"
  value       = module.rds.reader_endpoint
}

output "db_name" {
  description = "Назва бази даних"
  value       = module.rds.db_name
}

output "rds_security_group_id" {
  description = "ID Security Group для БД"
  value       = module.rds.security_group_id
}

output "aurora_writer_instance_id" {
  description = "ID Writer інстансу Aurora"
  value       = module.rds.aurora_writer_instance_id
}

output "aurora_reader_instance_ids" {
  description = "Список ID Reader інстансів Aurora"
  value       = module.rds.aurora_reader_instance_ids
}