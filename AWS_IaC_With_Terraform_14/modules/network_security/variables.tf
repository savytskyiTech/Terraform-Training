variable "vpc_id" {
  description = "VPC ID in which to create the security groups."
  type        = string
}

variable "allowed_ip_range" {
  description = "IPv4 CIDR ranges permitted to access SSH and public HTTP."
  type        = list(string)
}

variable "security_group_names" {
  description = "AWS names for the SSH, public HTTP, and private HTTP security groups."
  type = object({
    ssh          = string
    public_http  = string
    private_http = string
  })
}

variable "tags" {
  description = "Common tags applied to security groups."
  type        = map(string)
}
