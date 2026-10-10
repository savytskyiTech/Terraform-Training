variable "aws_region" {
  description = "AWS Region used by the provider."
  type        = string
}

variable "policy_name" {
  description = "Name of the existing IAM policy imported into this state."
  type        = string
}

variable "policy_description" {
  description = "Description of the existing IAM policy."
  type        = string
}

variable "policy_actions" {
  description = "Actions allowed by the existing IAM policy document."
  type        = list(string)
}
