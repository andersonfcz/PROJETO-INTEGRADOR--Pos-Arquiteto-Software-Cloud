output "lb_ip" {
  value = aws_lb.inventory-lb.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "db_name" {
  value = aws_db_instance.default.db_name
}

output "db_username" {
  value = aws_db_instance.default.username
}

