variable "aws_region" {
  description = "AWS Region containing the existing infrastructure and the new EC2 instance."
  type        = string
}

variable "project_id" {
  description = "Project identifier used to name and tag the EC2 instance."
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the existing VPC."
  type        = string
}

variable "public_subnet_name" {
  description = "Name tag of the existing public subnet."
  type        = string
}

variable "security_group_name" {
  description = "Name tag of the existing EC2 security group."
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance."
  type        = string
}
