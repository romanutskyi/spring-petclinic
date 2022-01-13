output "instance_id" {
  description = "ID of the application EC2 instance"
  value       = aws_instance.app-srv.id
}

output "instance_public_ip" {
  description = "Public IP address of the application EC2 instance"
  value       = aws_instance.app-srv.public_ip
}

output "public_dns" {
  description = "The public DNS name assigned to the application instance"
  value       = aws_instance.app-srv.public_dns
}
