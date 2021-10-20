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

# Another subnet in different az for meeting AZ coverage requirement for db instance
resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc-wp-blog.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    "Name" = "private-subnet-2"
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
# Open traffic to port 3306 from webserver private ip 
resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "security group for database in private subnet"
  vpc_id      = aws_vpc.vpc-wp-blog.id

  ingress {
    description = "allow port 3306 from our webserver private ip"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${aws_instance.webserver-instance.private_ip}/32"]

  }

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
  ami                         = var.image_id
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

# Create a db subnet group
resource "aws_db_subnet_group" "mydb-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private-subnet.id, aws_subnet.private-subnet-2.id]
  tags = {
    "Name" = "My db subnet group"
  }
}

# Create a database instance in private subnet
resource "aws_db_instance" "blog-database" {
  engine              = "mysql"
  instance_class      = "db.t2.micro"
  engine_version      = "8.0.23"
  name                = "DbWp"
  username            = var.db_username
  password            = var.db_password
  allocated_storage   = 10
  publicly_accessible = false
  skip_final_snapshot = true
  depends_on = [
    aws_db_subnet_group.mydb-subnet-group
  ]
  vpc_security_group_ids = ["${aws_security_group.database-sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.mydb-subnet-group.name
  identifier             = "blog-db-instance"
  tags = {
    "Name" = "my-wp-database"
  }
}

