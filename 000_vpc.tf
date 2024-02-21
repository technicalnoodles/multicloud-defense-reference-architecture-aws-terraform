# Create prod VPC
resource "aws_vpc" "prod" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod"
  }
}

# Create dev VPC
resource "aws_vpc" "dev" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod"
  }
}

# Create mgmt VPC
resource "aws_vpc" "mgmt" {
  cidr_block           = "10.100.1.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "shared-mgmt"
  }
}