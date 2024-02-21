#Create Subnets

#prod subnets
resource "aws_subnet" "db-subnet-a" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "db-subnet-a"
  }

  depends_on = [aws_vpc.prod]
}

resource "aws_subnet" "db-subnet-b" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-west-2c"
  tags = {
    Name = "db-subnet-b"
  }

  depends_on = [aws_vpc.prod]
}

resource "aws_subnet" "backend-subnet-a" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.1.11.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "backend-subnet-a"
  }

  depends_on = [aws_vpc.prod]
}

resource "aws_subnet" "backend-subnet-b" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.1.12.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "backend-subnet-b"
  }

  depends_on = [aws_vpc.prod]
}

resource "aws_subnet" "frontend-subnet-a" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.1.21.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "frontend-subnet-a"
  }

  depends_on = [aws_vpc.prod]
}

resource "aws_subnet" "frontend-subnet-b" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.1.22.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "frontend-subnet-b"
  }

  depends_on = [aws_vpc.prod]
}

resource "aws_subnet" "prod-internet-subnet" {
  vpc_id     = aws_vpc.prod.id
  cidr_block = "10.1.100.0/24"

  tags = {
    Name = "prod-internet-subnet"
  }
  depends_on = [aws_vpc.prod]
}

#dev subnets
resource "aws_subnet" "dev-db-subnet-a" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "db-subnet-a"
  }

  depends_on = [aws_vpc.dev]
}

resource "aws_subnet" "dev-db-subnet-b" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "us-west-2c"
  tags = {
    Name = "db-subnet-b"
  }

  depends_on = [aws_vpc.dev]
}

resource "aws_subnet" "dev-backend-subnet-a" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "backend-subnet-a"
  }

  depends_on = [aws_vpc.dev]
}

resource "aws_subnet" "dev-backend-subnet-b" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.10.12.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "backend-subnet-b"
  }

  depends_on = [aws_vpc.dev]
}

resource "aws_subnet" "dev-frontend-subnet-a" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.10.21.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "frontend-subnet-a"
  }

  depends_on = [aws_vpc.dev]
}

resource "aws_subnet" "dev-frontend-subnet-b" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.10.22.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "frontend-subnet-b"
  }

  depends_on = [aws_vpc.dev]
}

resource "aws_subnet" "dev-internet-subnet" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.10.100.0/24"

  tags = {
    Name = "dev-internet-subnet"
  }
  depends_on = [aws_vpc.dev]
}

#mgmt subnets
resource "aws_subnet" "mgmt-internet-subnet" {
  vpc_id     = aws_vpc.mgmt.id
  cidr_block = "10.100.1.0/28"

  tags = {
    Name = "mgmt-internet-subnet"
  }
  depends_on = [aws_vpc.mgmt]
}

resource "aws_subnet" "mgmt-scanning-subnet" {
  vpc_id     = aws_vpc.mgmt.id
  cidr_block = "10.100.1.16/28"

  tags = {
    Name = "mgmt-scanning-subnet"
  }
  depends_on = [aws_vpc.mgmt]
}