# resource "aws_security_group" "prod-backend-to-db" {
#   name        = "prod-backend-to-db"
#   description = "Allow LB to backend"
#   vpc_id      = aws_vpc.prod.id

#   ingress {
#     description = "Mongo Access"
#     from_port   = 27017
#     to_port     = 27017
#     protocol    = "tcp"
#     cidr_blocks = [aws_subnet.backend-subnet-a.cidr_block, aws_subnet.backend-subnet-b.cidr_block]
#   }


#   tags = {
#     Name = "mongo access"
#   }
# }

resource "aws_security_group" "docdb-access" {
  name        = "prod-docdb-access"
  description = "Allow docdb access"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "DocDB port ingress"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.prod.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "prod-docdb-access"
  }
}

resource "aws_security_group" "dev-docdb-access" {
  name        = "dev-docdb-access"
  description = "Allow docdb access"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "DocDB port ingress"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.dev.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dev-docdb-access"
  }
}