terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.app_region
}

# Create a new VPC for our application
resource "aws_vpc" "vpc_wp_blog" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "blog"
  }
}