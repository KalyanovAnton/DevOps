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
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  default     = "lesson-5-vpc"
}

variable "ecr_name" {
  type        = string
  default     = "lesson-5-ecr"
}

variable "cluster_name" {
  type        = string
  default     = "eks-cluster-demo"
}

variable "instance_type" {
  type        = string
  default     = "t3.small" # Ментор просив звернути увагу на HPA, для нормальної роботи краще t3.small замість micro
}

variable "desired_size" {
  type        = number
  default     = 2 # Для HPA з minReplicas: 2 краще мати хоча б 2 ноди на старті
}

variable "max_size" {
  type        = number
  default     = 4
}

variable "min_size" {
  type        = number
  default     = 2
}