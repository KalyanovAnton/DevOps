terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.bucket_name
  table_name  = var.dynamodb_table_name
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_name           = var.vpc_name
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"          
  cluster_name    = var.cluster_name
  subnet_ids      = module.vpc.public_subnets
  instance_type   = var.instance_type
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
}