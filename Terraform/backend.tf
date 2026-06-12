terraform {
  backend "s3" {
    bucket  = "actionspipeline1000"
    key     = "actionspipeline1000/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}