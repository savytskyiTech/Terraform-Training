variable "aws_region" {
  description = "AWS Region where the application resources are deployed."
  type        = string
}

variable "project_id" {
  description = "Project identifier used to find existing resources and name new resources."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the launch template."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks of the two existing public subnets used by the load balancer and Auto Scaling group."
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group."
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling group."
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling group."
  type        = number
}
