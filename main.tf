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

# Create a public subnet for webserver
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
resource "aws_security_group" "webserver-sg" {
  name        = "webserver-sg"
  description = "allow http at port 80 and ssh at port 22 on webserver instance"
  vpc_id      = aws_vpc.vpc-wp-blog.id

  ingress {
    description = "SSH for webserver"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow http inbound traffic to webserver"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all outbound traffics"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver"
  }

}
# Create a security group rule for database instance
# By default deny all
resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "security group for database in private subnet"

  tags = {
    "Name" = "database"
  }
}

# Create an internet gateway for blog VPC
resource "aws_internet_gateway" "my-ig" {
  vpc_id = aws_vpc.vpc-wp-blog.id

  tags = {
    "Name" = "blog-ig"
  }
}

# Add route to the main route table of blog vpc
resource "aws_route" "public-subnet-route" {
  route_table_id         = aws_vpc.vpc-wp-blog.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-ig.id

}

# Create a webserver instance in public subnet
resource "aws_instance" "webserver-instance" {
  ami                         = "ami-05c029a4b57edda9e"
  instance_type               = var.webserver_instance_type
  availability_zone           = var.az
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  depends_on = [aws_security_group.webserver-sg,
    aws_route.public-subnet-route
  ]
  vpc_security_group_ids = ["${aws_security_group.webserver-sg.id}"]

  user_data = <<EOF
        #!/bin/bash
        yum -y update
        yum install -y httpd
        systemctl start httpd.service
        systemctl enable httpd.service
        echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF



}

# Create a database instance in private subnet

