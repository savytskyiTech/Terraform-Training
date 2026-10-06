output "load_balancer_dns_name" {
  description = "DNS name of the application load balancer serving the instance details."
  value       = aws_lb.application.dns_name
}
