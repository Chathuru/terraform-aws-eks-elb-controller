terraform {
  required_version = ">= 1.0.0"

  //backend "s3" {
  //  bucket  = "terraform-state"
  //  key     = "dev/terraform.tfstate"
  //  region  = "us-east-1"
  //  profile = "default"
  //}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.56.0"
    }
    kubernetes = {
      source  = "hashicorp/tls"
      version = ">= 2.6.1"
    }
    helm = {
      source  = "hashicorp/tls"
      version = ">= 2.4.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
  }
}
