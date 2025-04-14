#Import outputs from VPC state file
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "global/groupone/vpc/terraform.tfstate"
    region = var.region
  }
}