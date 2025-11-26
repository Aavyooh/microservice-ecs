resource "aws_secretsmanager_secret" "db_creds" {
  name = "${var.env}-wordpress-db-creds"
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = aws_secretsmanager_secret.db_creds.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = var.rds_endpoint
    dbname   = "wordpress"
  })
}

