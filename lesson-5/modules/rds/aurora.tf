# Parameter Group для Aurora Cluster
resource "aws_rds_cluster_parameter_group" "aurora" {
  count       = var.use_aurora ? 1 : 0
  name        = "${var.name}-aurora-pg"
  family      = var.parameter_group_family_aurora
  description = "Aurora Cluster PG for ${var.name}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  tags = var.tags
}

# AWS Aurora Cluster
resource "aws_rds_cluster" "aurora" {
  count                           = var.use_aurora ? 1 : 0
  cluster_identifier              = "${var.name}-aurora-cluster"
  engine                          = var.engine_cluster
  engine_version                  = var.engine_version_cluster
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = var.password
  db_subnet_group_name            = aws_db_subnet_group.default.name
  vpc_security_group_ids          = [aws_security_group.rds.id]
  backup_retention_period         = var.backup_retention_period # <-- Спрощено
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name
  skip_final_snapshot             = true

  tags = var.tags
}

# Інстанси всередині Aurora Cluster (Primary + Replicas)
resource "aws_rds_cluster_instance" "aurora_instances" {
  count                = var.use_aurora ? var.aurora_instance_count : 0
  identifier           = "${var.name}-aurora-node-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.aurora[0].id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.aurora[0].engine
  engine_version       = aws_rds_cluster.aurora[0].engine_version
  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = var.tags
}

# Subnet Group для БД
resource "aws_db_subnet_group" "default" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.publicly_accessible ? var.subnet_public_ids : var.subnet_private_ids
  tags       = var.tags
}

# Security group (використовується для RDS та Aurora)
resource "aws_security_group" "rds" {
  name        = "${var.name}-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}