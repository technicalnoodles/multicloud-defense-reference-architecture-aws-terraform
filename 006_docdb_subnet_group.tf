resource "aws_docdb_subnet_group" "prod-db-subnet-group" {
  name       = "prod-db-subnet-group"
  subnet_ids = [aws_subnet.db-subnet-a.id, aws_subnet.db-subnet-b.id]

  tags = {
    Name = "prod-db-subnet-group"
  }
  depends_on = [aws_route.prod-backend-internet-route]
}

resource "aws_docdb_subnet_group" "dev-db-subnet-group" {
  name       = "dev-db-subnet-group"
  subnet_ids = [aws_subnet.dev-db-subnet-a.id, aws_subnet.dev-db-subnet-b.id]

  tags = {
    Name = "dev-db-subnet-group"
  }
  depends_on = [aws_route.dev-backend-internet-route]
}