variable "region" {
  type        = string
  description = "AWS region containing the existing VPC and EC2 instances"
}

variable "project_id" {
  type        = string
  description = "Project ID used to name and tag the security groups"
}

variable "allowed_ip_range" {
  type        = list(string)
  description = "IPv4 CIDR ranges allowed to reach the public security groups"
}

variable "vpc_id" {
  type        = string
  description = "ID of the existing VPC"
}

variable "public_subnet_id" {
  type        = string
  description = "ID of the existing public subnet"
}

variable "private_subnet_id" {
  type        = string
  description = "ID of the existing private subnet"
}

variable "public_instance_id" {
  type        = string
  description = "ID of the existing public EC2 instance"
}

variable "private_instance_id" {
  type        = string
  description = "ID of the existing private EC2 instance"
}
