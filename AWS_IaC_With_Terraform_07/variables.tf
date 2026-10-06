variable "aws_region" {
  description = "AWS Region for the EC2 instance and remote state bucket."
  type        = string
}

variable "project_id" {
  description = "Project identifier used to name and tag the EC2 instance."
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket containing the landing zone Terraform state."
  type        = string
}

variable "state_key" {
  description = "S3 object key of the landing zone Terraform state."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to launch in the public subnet."
  type        = string
}
