resource "aws_db_instance" "default" {
  allocated_storage       = 5
  max_allocated_storage   = 10
  db_name                 = var.db_name
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.db_user
  password                = var.db_password
  skip_final_snapshot     = true
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.db.id
  vpc_security_group_ids  = [aws_security_group.db.id]
  backup_retention_period = 0

}