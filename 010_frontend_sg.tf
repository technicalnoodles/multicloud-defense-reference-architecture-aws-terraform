resource "aws_security_group" "prod-frontend-to-backend-lb-sg" {
  name        = "prod-frontend-to-backend-lb-sg"
  description = "Allow frontend to backend lb"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.frontend-subnet-a.cidr_block, aws_subnet.frontend-subnet-b.cidr_block]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.frontend-subnet-a.cidr_block, aws_subnet.frontend-subnet-b.cidr_block]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.frontend-subnet-a.cidr_block, aws_subnet.frontend-subnet-b.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow frontend to backend lb"
  }
}

#dev
resource "aws_security_group" "dev-frontend-to-backend-lb-sg" {
  name        = "dev-frontend-to-backend-lb-sg"
  description = "Allow frontend to backend lb"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.dev-frontend-subnet-a.cidr_block, aws_subnet.dev-frontend-subnet-b.cidr_block]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.dev-frontend-subnet-a.cidr_block, aws_subnet.dev-frontend-subnet-b.cidr_block]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.dev-frontend-subnet-a.cidr_block, aws_subnet.dev-frontend-subnet-b.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow frontend to backend lb"
  }
}