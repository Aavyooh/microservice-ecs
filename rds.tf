################# rds-subnet-group #################

resource "aws_db_subnet_group" "dev_wp_db_subnet_group" {
  name        = "dev-wp-db-subnet-group"
  description = "Subnet group for WordPress MySQL database"

  subnet_ids = module.vpc.private_subnets  # Private subnets used for ECS

  tags = {
    Name = "dev-wp-db-subnet-group"
  }
}

################# secrets manager #################

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "dev-wp-db-credentials"
  description = "Credentials for WordPress MySQL DB"
  recovery_window_in_days = 0  # Allow immediate delete during destroy
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = "admin"
    password = random_password.db.result
  })
}

resource "random_password" "db" {
  length  = 20
  special = true
  override_special = "!#$%^&*()-_=+[]{}<>?~"
}


################# rds mysql instance #################

resource "aws_db_instance" "dev_wp_rds" {
  identifier           = "database"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"              # Free tier compatible
  instance_class       = "db.t3.micro"      # Free tier-compatible
  username             = jsondecode(aws_secretsmanager_secret_version.db_credentials_value.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.db_credentials_value.secret_string)["password"]

  db_subnet_group_name = aws_db_subnet_group.dev_wp_db_subnet_group.name
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  # Required for production
  skip_final_snapshot = true

  publicly_accessible = false  # Private only

   # Enable automated backups
  backup_retention_period  = 7     # Keep backups for 7 days
  backup_window            = "01:00-03:00"  # UTC window for backups

  tags = {
    Name = "dev-wp-rds"
  }
}
