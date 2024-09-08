provider "aws" {
  region = "us-east-1" # Specify the AWS region
}

terraform {
  backend "s3" {
    bucket  = "sb-tf-statef"                              # S3 bucket name
    key     = "sb-tf-statef/statefiles/terraform.tfstate" # Path to store the state file in S3
    region  = "us-east-1"                                 # AWS region where the bucket is located
    encrypt = true                                        # Encrypt the state file in S3
    #dynamodb_table = "terraform-state-lock"     # Optional: DynamoDB table for state locking
  }
}

# Create a VPC
resource "aws_vpc" "tfaws_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "tf-aws-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "tfaws_subnet" {
  vpc_id            = aws_vpc.tfaws_vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "tfaws_igw" {
  vpc_id = aws_vpc.tfaws_vpc.id
}

# Create a Route Table
resource "aws_route_table" "tfaws_route_table" {
  vpc_id = aws_vpc.tfaws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tfaws_igw.id
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "tfaws_route_table_association" {
  subnet_id      = aws_subnet.tfaws_subnet.id
  route_table_id = aws_route_table.tfaws_route_table.id
}

# Security Group to allow SSH and HTTP access
resource "aws_security_group" "tfaws_sg" {
  vpc_id = aws_vpc.tfaws_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "tfaws_instance" {
  ami           = "ami-0182f373e66f89c85" # Replace with the latest Amazon Linux AMI ID for your region
  instance_type = "t3a.medium"

  subnet_id                   = aws_subnet.tfaws_subnet.id
  vpc_security_group_ids      = [aws_security_group.tfaws_sg.id] # Use the security group ID
  associate_public_ip_address = true

  tags = {
    Name = "tfawsInstance"
  }

  # Automatically configure the instance with a startup script
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}


# Output the public IP of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.tfaws_instance.public_ip
}