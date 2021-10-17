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

# Create a public subnet webserver

# Create a private subnet for database

# Create a security group rule for webserver

# Create a security group rule for database instance

# Create a webserver instance in public subnet

# Create a database instance in private subnet

