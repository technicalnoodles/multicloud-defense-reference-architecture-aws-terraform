terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19"
    }
    # valtix = {
    #   source = "valtix-security/valtix"
    #   # version = "22.12.1"
    # }
    time = {
      source = "hashicorp/time"
    }
    ciscomcd = {
      source  = "CiscoDevNet/ciscomcd"
      version = "0.2.3"
    }
  }
}

provider "aws" {
  region                   = "us-west-2"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  # profile                  = "terraform"
}

# provider "valtix" {
#   api_key_file = file("${path.module}/mcd-terraform.json")
# }

provider "ciscomcd" {
  api_key_file = file("${path.module}/mcd-terraform.json")
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}