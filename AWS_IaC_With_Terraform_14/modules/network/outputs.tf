output "vpc_id" {
  description = "ID of the VPC managed by this module."
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "Public subnet IDs with the internet route and route table associations configured."
  value       = [for subnet in aws_subnet.public : subnet.id]

  depends_on = [aws_route_table.public, aws_route_table_association.public]
}
