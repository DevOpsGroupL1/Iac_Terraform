variable "region" {
  description = "The region in which the VPC will be created."
  type        = string
}

variable "Owner" {
  description = "The owner of the terraform configuration file."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC."
  type        = bool
}

variable "private_subnet_count" {
  description = "The number of private subnets to create."
  type        = number
}

variable "public_subnet_count" {
  description = "The number of public subnets to create."
  type        = number
}

variable "availability_zones" {
  description = "The availability zones in which the subnets will be created."
  type        = list(string)
}

variable "rt_cidr_block" {
  description = "The CIDR block for the route table."
  type        = string
}