variable "region" {
  description = "The region in which the VPC will be created."
  type        = string
}

variable "bucket_name" {
  description = "The s3 backend bucket name"
}

variable "Owner" {
  description = "The owner of the terraform configuration file."
  type        = string
}

variable "subnet_group_name" {
  description = "The name of the db subnet group."
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage to be allocated for the database."
  type        = number
}

variable "storage_type" {
  description = "The type of storage to be used for the database."
  type        = string
}

variable "engine" {
  description = "The name of the database engine to be used."
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine to be used."
  type        = string
}

variable "instance_class" {
  description = "The class of the database instance to be created."
  type        = string
}

variable "username" {
  description = "The username of the database master user."
  type        = string
}

variable "password" {
  description = "The password for the database master user."
  type        = string
}

variable "DB-name" {
  description = "The name of the database to be created."
  type        = string
}