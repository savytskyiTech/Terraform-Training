variable "aws_region" {
  description = "AWS Region containing the existing network and application resources."
  type        = string
}

variable "project_id" {
  description = "Project identifier used to discover, name, and tag resources."
  type        = string
}

variable "public_subnet_names" {
  description = "Name tags of the existing public subnets in two availability zones."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type used by the Blue and Green launch templates."
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances in each environment's Auto Scaling group."
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in each environment's Auto Scaling group."
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in each environment's Auto Scaling group."
  type        = number
}

variable "blue_weight" {
  description = "Relative weight of HTTP traffic forwarded to the Blue target group."
  type        = number

  validation {
    condition     = var.blue_weight >= 0 && var.blue_weight <= 999 && floor(var.blue_weight) == var.blue_weight
    error_message = "The Blue traffic weight must be an integer between 0 and 999."
  }
}

variable "green_weight" {
  description = "Relative weight of HTTP traffic forwarded to the Green target group."
  type        = number

  validation {
    condition     = var.green_weight >= 0 && var.green_weight <= 999 && floor(var.green_weight) == var.green_weight
    error_message = "The Green traffic weight must be an integer between 0 and 999."
  }
}
