resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-rds"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds" {
  name   = "${var.env}-rds-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ecs_tasks_sg_id]
  }
}

resource "aws_db_instance" "main" {
  identifier              = "${var.env}-wordpress"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp3"
  username                = var.db_username
  password                = var.db_password
  db_name                 = "wordpress"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  multi_az                = false
  backup_retention_period = 7
  skip_final_snapshot     = true
  publicly_accessible     = false
  storage_encrypted       = true
  apply_immediately       = true

  # Prevent rotation
  # manage_master_user_password = false
}

