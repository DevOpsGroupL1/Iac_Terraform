terraform {
  backend "s3" {
    key = "global/groupone/ec2/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ManagedBy = var.Owner
    }
  }
}
