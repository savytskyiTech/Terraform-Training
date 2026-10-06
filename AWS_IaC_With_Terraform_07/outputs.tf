output "instance_id" {
  description = "ID of the EC2 instance in the landing zone public subnet."
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IPv4 address assigned to the EC2 instance."
  value       = aws_instance.main.public_ip
}
