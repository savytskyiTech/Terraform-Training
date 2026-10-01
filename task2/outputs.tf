output "instance_public_ip" {
  value       = aws_instance.main.public_ip
  description = "The public IP adress of the EC2 instance for SSH access"
}