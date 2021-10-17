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
resource "aws_vpc" "vpc-wp-blog" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "blog"
  }
}

# Create a public subnet webserver
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc-wp-blog.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = var.az
  tags = {
    "Name" = "public-subnet"
  }
}

# Create a private subnet for database
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc-wp-blog.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = var.az
  tags = {
    "Name" = "private-subnet"
  }
}

# Create a security group rule for webserver

# Create a security group rule for database instance

# Create a webserver instance in public subnet

# Create a database instance in private subnet

