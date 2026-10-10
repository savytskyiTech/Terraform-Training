output "application_url" {
  description = "HTTP URL of the load balancer serving the Blue and Green environments."
  value       = "http://${aws_lb.application.dns_name}"
}

output "target_group_arns" {
  description = "Target group ARNs keyed by Blue or Green environment."
  value       = { for environment, group in aws_lb_target_group.environment : environment => group.arn }
}

output "autoscaling_group_names" {
  description = "Auto Scaling group names keyed by Blue or Green environment."
  value       = { for environment, group in aws_autoscaling_group.environment : environment => group.name }
}
