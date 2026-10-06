output "instance_id" {
  description = "ID of the EC2 instance launched in the discovered public subnet."
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IPv4 address of the EC2 instance."
  value       = aws_instance.main.public_ip
}
