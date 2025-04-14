data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "global/groupone/vpc/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "global/groupone/ec2/terraform.tfstate"
    region = var.region
  }
}