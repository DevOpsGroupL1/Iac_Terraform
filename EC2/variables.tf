variable "region" {
  description = "The region in which the VPC will be created."
}

variable "bucket_name" {
  description = "The s3 backend bucket name"
}

variable "Owner" {
  description = "The owner of the terraform configuration file."
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances."
  type        = string
}

variable "pub_ec2_count" {
  description = "The number of EC2 instances to create."
  type        = number
}

variable "ami" {
  description = "The AMI to use for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = list(string)
}

variable "server_name" {
  description = "The names of the EC2 instances."
  type        = list(string)
}

variable "security_group_name" {
  description = "The name of the security group to create."
  type        = list(string)
}

variable "ingress_rules" {
  description = "A list of ingress rules to apply to the security group."
  type = list(list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })))
}

variable "grp1_ec2_egress_cidr_blocks" {
  description = "The CIDR blocks to allow egress traffic to."
  type        = list(string)
}