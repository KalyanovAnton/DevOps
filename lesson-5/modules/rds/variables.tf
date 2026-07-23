variable "name" {
  type        = string
  description = "Base name for RDS resources, instances, and security groups"
}

variable "engine" {
  type        = string
  default     = "postgres"
  description = "Database engine for regular RDS (e.g., postgres, mysql)"
}

variable "engine_cluster" {
  type        = string
  default     = "aurora-postgresql"
  description = "Database engine for Aurora cluster"
}

variable "aurora_instance_count" {
  type        = number
  default     = 2
  description = "Number of instances in the Aurora cluster (1 primary + replicas)"
}

variable "engine_version" {
  type        = string
  default     = "17"
  description = "Engine version for standalone RDS"
}

variable "engine_version_cluster" {
  type        = string
  default     = "15.3"
  description = "Engine version for Aurora cluster"
}

variable "parameter_group_family_rds" {
  type        = string
  default     = "postgres17"
  description = "Parameter group family for standalone RDS"
}

variable "parameter_group_family_aurora" {
  type        = string
  default     = "aurora-postgresql15"
  description = "Parameter group family for Aurora cluster"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "Database instance class size"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Allocated storage size in GB for standalone RDS"
}

variable "db_name" {
  type        = string
  default     = "myapp"
  description = "Name of the initial database to create"
}

variable "username" {
  type        = string
  default     = "dbadmin"
  description = "Master username for database access"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Master password for database access"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Security Group for database will be created"
}

variable "subnet_private_ids" {
  type        = list(string)
  description = "List of private subnet IDs for database subnet group"
}

variable "subnet_public_ids" {
  type        = list(string)
  default     = []
  description = "List of public subnet IDs for database subnet group"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Controls if instance is publicly accessible from outside VPC"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Specifies if the RDS instance is Multi-AZ"
}

variable "use_aurora" {
  type        = bool
  default     = false
  description = "Flag to enable Aurora cluster instead of standalone RDS instance"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain automated backups"
}

variable "parameters" {
  type = map(string)
  default = {
    max_connections = "100"
    log_statement   = "all"
    work_mem        = "4096"
  }
  description = "Database parameters for the custom parameter group"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "CIDR blocks allowed to access the database"
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "Database port for network rules"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to all resources"
}