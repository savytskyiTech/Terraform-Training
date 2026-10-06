output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "IPv4 CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets, ordered by subnet suffix."
  value       = [for key in sort(keys(var.public_subnets)) : aws_subnet.public[key].id]
}

output "public_subnet_cidr_block" {
  description = "IPv4 CIDR blocks of the public subnets, ordered by subnet suffix."
  value       = [for key in sort(keys(var.public_subnets)) : aws_subnet.public[key].cidr_block]
}

output "public_subnet_availability_zone" {
  description = "Availability Zones of the public subnets, ordered by subnet suffix."
  value       = [for key in sort(keys(var.public_subnets)) : aws_subnet.public[key].availability_zone]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the VPC."
  value       = aws_internet_gateway.main.id
}

output "routing_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}
