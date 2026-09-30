variable "aws_region" {
  type        = string
  description = "AWS Region for deployment"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Main CIDR block for VPC"
}

variable "subnet_a_name" {
  type        = string
  description = "Name for subnet in A AZ"
}

variable "az_a" {
  type        = string
  description = "az a"
}

variable "subnet_a_cidr_block" {
  type        = string
  description = "CIDR block for subnet_a"
}

variable "subnet_b_name" {
  type        = string
  description = "Name for subnet in B AZ"
}

variable "az_b" {
  type        = string
  description = "az b"
}

variable "subnet_b_cidr_block" {
  type        = string
  description = "CIDR block for subnet_b"
}

variable "subnet_c_name" {
  type        = string
  description = "Name for subnet in C AZ"
}

variable "az_c" {
  type        = string
  description = "az c"
}


variable "subnet_c_cidr_block" {
  type        = string
  description = "CIDR block for subnet_c"
}


variable "igw_name" {
  type        = string
  description = "Name of Internet Gateway"
}

variable "aws_rt_name" {
  type        = string
  description = "Name of route table"
}