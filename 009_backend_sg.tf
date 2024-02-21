resource "aws_security_group" "prod-lb-to-backend" {
  name        = "prod-lb-to-backend"
  description = "Allow LB to backend"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.backend-subnet-a.cidr_block, aws_subnet.backend-subnet-b.cidr_block]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.backend-subnet-a.cidr_block, aws_subnet.backend-subnet-b.cidr_block]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.backend-subnet-a.cidr_block, aws_subnet.backend-subnet-b.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "tshoot" {
  name        = "tshoot"
  description = "Allow access"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "allow all"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tshoot"
  }
}

# dev
resource "aws_security_group" "dev-lb-to-backend" {
  name        = "dev-lb-to-backend"
  description = "Allow LB to backend"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.dev-backend-subnet-a.cidr_block, aws_subnet.dev-backend-subnet-b.cidr_block]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.dev-backend-subnet-a.cidr_block, aws_subnet.dev-backend-subnet-b.cidr_block]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.dev-backend-subnet-a.cidr_block, aws_subnet.dev-backend-subnet-b.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "dev-tshoot" {
  name        = "dev-tshoot"
  description = "Allow access"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "allow all"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dev-tshoot"
  }
}