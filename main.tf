terraform {
  backend "s3" {
    bucket = "s3backendbucket-123456"
    key    = "btest/terraform.tfstate"
    region = "us-east-1"
  }
}





provider "aws" {
  region = "us-east-1"
}

