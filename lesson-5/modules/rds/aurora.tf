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
  backup_retention_period         = var.backup_retention_period
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name
  skip_final_snapshot             = true

  tags = var.tags
}

resource "aws_rds_cluster_instance" "writer" {
  count                = var.use_aurora ? 1 : 0
  identifier           = "${var.name}-aurora-writer"
  cluster_identifier   = aws_rds_cluster.aurora[0].id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.aurora[0].engine
  engine_version       = aws_rds_cluster.aurora[0].engine_version
  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = merge(
    var.tags,
    {
      Role = "writer"
    }
  )
}

resource "aws_rds_cluster_instance" "readers" {
  count                = var.use_aurora ? var.aurora_reader_count : 0
  identifier           = "${var.name}-aurora-reader-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.aurora[0].id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.aurora[0].engine
  engine_version       = aws_rds_cluster.aurora[0].engine_version
  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = merge(
    var.tags,
    {
      Role = "reader"
    }
  )
}