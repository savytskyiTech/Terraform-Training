variable "vpc_id" {
  description = "VPC ID used by the load balancer target group."
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs used by the load balancer and Auto Scaling group."
  type        = list(string)
}

variable "security_group_ids" {
  description = "SSH and private HTTP groups for EC2, and the public HTTP group for the load balancer."
  type = object({
    ssh          = string
    public_http  = string
    private_http = string
  })
}

variable "ami_name_pattern" {
  description = "Amazon-owned AMI name pattern for the latest compatible image."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type used by the launch template."
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances managed by the Auto Scaling group."
  type        = number
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling group."
  type        = number
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling group."
  type        = number
}

variable "resource_names" {
  description = "AWS names for the launch template, ASG, load balancer, target group, and instances."
  type = object({
    launch_template = string
    autoscaling     = string
    load_balancer   = string
    target_group    = string
    instance        = string
  })
}

variable "tags" {
  description = "Common tags for application resources and launched instances."
  type        = map(string)
}
