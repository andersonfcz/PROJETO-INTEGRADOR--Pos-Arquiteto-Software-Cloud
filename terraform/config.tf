terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46"
    }
  }

  backend "s3" {
    bucket = "projeto-integrador-terraform-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}