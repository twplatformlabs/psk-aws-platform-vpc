terraform {
  required_version = "~> 1.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.40"
    }
  }

  # The backend cloud store is managed using the terraform orb tfc-backend command.
  # this command will generate the appropriate template for the tf workspace: DO NOT UNCOMMENT
  #
  # terraform {
  #   cloud {
  #     organization = "${TFC_ORGANIZATION}"
  #     hostname = "app.terraform.io"

  #     workspaces {
  #       name = "${TFC_WORKSPACE}"
  #     }
  #   }
  # }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role}"
    session_name = "psk-aws-platform-vpc-${var.cluster_name}"
  }

  default_tags {
    tags = {
      env      = var.cluster_name
      cluster  = var.cluster_name
      pipeline = "psk-aws-platform-vpc"
    }
  }
}
