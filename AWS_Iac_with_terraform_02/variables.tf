variable "ssh_key" {
  type        = string
  description = "Provides custom public SSH key"
}

variable "aws_region" {
  type        = string
  description = "eu-west-1"
}

variable "project_name" {
  type        = string
  description = "Name of the project tags"
}

variable "resource_id" {
  type        = string
  description = "ID for resource naming & tagging"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}
