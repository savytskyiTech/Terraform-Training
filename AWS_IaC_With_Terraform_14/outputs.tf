output "vpc_id" {
  description = "ID of the VPC created by the network module."
  value       = module.network.vpc_id
}

output "subnet_ids" {
  description = "IDs of the three public subnets created by the network module."
  value       = module.network.subnet_ids
}

output "security_group_ids" {
  description = "SSH, public HTTP, and private HTTP security group IDs."
  value       = module.network_security.security_group_ids
}

output "load_balancer_dns_name" {
  description = "DNS name of the application load balancer."
  value       = module.application.load_balancer_dns_name
}

output "application_url" {
  description = "HTTP URL of the application served by the load balancer."
  value       = "http://${module.application.load_balancer_dns_name}"
}
