variable "aws_region" {
  description = "AWS Region in which to create the infrastructure."
  type        = string
}

variable "project_id" {
  description = "Project identifier used to generate resource names and tags."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the application VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnets keyed by stable identifiers, with names, IPv4 CIDRs, and availability zones."
  type = map(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "allowed_ip_range" {
  description = "IPv4 /32 ranges for the platform and the user's public connection, allowed to access SSH and public HTTP."
  type        = list(string)

  validation {
    condition = length(var.allowed_ip_range) >= 2 && alltrue([
      for cidr in var.allowed_ip_range : can(cidrnetmask(cidr)) && can(regex("/32$", cidr))
    ])
    error_message = "Provide at least two valid IPv4 /32 ranges for the platform and your public IP."
  }
}

variable "ami_name_pattern" {
  description = "Amazon-owned AMI name pattern used to select the most recent compatible image."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the launch template."
  type        = string
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
