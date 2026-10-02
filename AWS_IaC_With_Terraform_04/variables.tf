variable "project" {
  type        = string
  description = "Project tag for task verification"
}

variable "title" {
  type        = string
  description = "Name segment used to generate IAM resource names"
}

variable "region" {
  type        = string
  description = "AWS region for the IAM resources"
}

variable "bucket_name" {
  type        = string
  description = "Existing S3 bucket name used by the IAM policy"
}
