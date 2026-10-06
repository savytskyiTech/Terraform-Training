variable "aws_region" {
  description = "AWS Region in which to create the network resources."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to construct the names of network resources."
  type        = string
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks and Availability Zones, keyed by subnet suffix."
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
