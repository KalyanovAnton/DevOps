variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-west-2"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for terraform backend state"
  default     = "lesson-5-kalianov-bucket"
}

variable "dynamodb_table_name" {
  type        = string
  description = "DynamoDB table name for terraform locks"
  default     = "terraform-locks"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "lesson-5-vpc"
}

variable "ecr_name" {
  type    = string
  default = "lesson-5-ecr"
}

variable "cluster_name" {
  type    = string
  default = "eks-cluster-demo"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "min_size" {
  type    = number
  default = 2
}


variable "db_username" {
  type        = string
  description = "Master username for PostgreSQL database"
  default     = "dbadmin"
}

variable "db_password" {
  type        = string
  description = "Master password for PostgreSQL database"
  sensitive   = true
}