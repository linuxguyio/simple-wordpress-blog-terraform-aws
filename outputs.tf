output "ip-address" {
  description = "IP address of webserver"
  value       = aws_instance.webserver-instance.public_ip

}

output "database-endpoint" {
  description = "Endpoint for the database serever"
  value       = aws_db_instance.blog-database.endpoint

}
