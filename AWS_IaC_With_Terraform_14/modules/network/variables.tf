variable "vpc_name" {
  description = "Name tag for the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnet names, IPv4 CIDR blocks, and availability zones, keyed by stable identifiers."
  type = map(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "gateway_name" {
  description = "Name tag for the internet gateway."
  type        = string
}

variable "route_table_name" {
  description = "Name tag for the public route table."
  type        = string
}

variable "tags" {
  description = "Common tags applied to taggable network resources."
  type        = map(string)
}
