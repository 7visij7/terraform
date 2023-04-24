# Create random generated password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create AWS secret for database password
 
resource "aws_secretsmanager_secret" "dbPassword" {
  name            = "${var.app_name}-${var.environment_name}-dbPassword"
  description     = "${var.app_name}-${var.environment_name} DB password"
  tags = {
    Name = "${var.app_name}-${var.environment_name}"
  }
}
 
# Create AWS secret versions for database
 
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.dbPassword.id
  secret_string = <<EOF
   {
    "username": "${var.user_name}",
    "password": "${random_password.password.result}"
   }
EOF
}

# Create DB 
resource "aws_db_instance" "master" {
  name                   = "master"  
  identifier             = "${var.app_name}-${var.environment_name}-master"
  instance_class         = var.db_instance_class 
  storage_type           = "gp2"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.32"
  username               = var.user_name
  password               = "${random_password.password.result}"
  apply_immediately      = "true"
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.vpc_security_group_db]
  publicly_accessible    = false
  skip_final_snapshot    = true
}
