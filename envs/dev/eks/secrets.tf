resource "aws_secretsmanager_secret" "db" {
  name                    = "jerney/db"
  recovery_window_in_days = 0    # Immediate delete for dev

  tags = {
    Env       = var.env
    ManagedBy = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.db_name
  })
}
