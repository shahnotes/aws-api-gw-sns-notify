terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }

  backend "local" {
    path = "terraform.state.d"
  }

  # backend "s3" {
  #   bucket         = ""
  #   dynamodb_table = ""
  #   key            = ""
  #   region         = ""
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Privisioner = "terraform"
      Author      = var.author
      Environment = terraform.workspace
    }
  }
}