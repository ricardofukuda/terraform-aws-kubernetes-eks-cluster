terraform{
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
  }

  backend "s3" {
    bucket  = "eks-terraform-fukuda"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    profile = "ricardo"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "ricardo"
}