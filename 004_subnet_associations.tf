#associations internet
resource "aws_route_table_association" "prod-internet-subnet" {
  subnet_id      = aws_subnet.prod-internet-subnet.id
  route_table_id = aws_route_table.prod-internet-rt.id
  depends_on     = [aws_route_table.prod-internet-rt]
}

resource "aws_route_table_association" "prod-internet-gw" {
  gateway_id     = aws_internet_gateway.prod-internet-gw.id
  route_table_id = aws_route_table.prod-internet-rt.id
  depends_on     = [aws_route_table_association.prod-internet-subnet]
}

#dev internet
resource "aws_route_table_association" "dev-internet-subnet" {
  subnet_id      = aws_subnet.dev-internet-subnet.id
  route_table_id = aws_route_table.dev-internet-rt.id
  depends_on     = [aws_route_table.dev-internet-rt]
}

resource "aws_route_table_association" "dev-internet-gw" {
  gateway_id     = aws_internet_gateway.dev-internet-gw.id
  route_table_id = aws_route_table.dev-internet-rt.id
  depends_on     = [aws_route_table_association.dev-internet-subnet]
}


# db
resource "aws_route_table_association" "prod-dba-subnet" {
  subnet_id      = aws_subnet.db-subnet-a.id
  route_table_id = aws_route_table.prod-db-rt.id
  depends_on     = [aws_route_table_association.prod-internet-gw]
}

resource "aws_route_table_association" "prod-dbb-subnet" {
  subnet_id      = aws_subnet.db-subnet-b.id
  route_table_id = aws_route_table.prod-db-rt.id
  depends_on     = [aws_route_table_association.prod-internet-gw]
}

# dev db
resource "aws_route_table_association" "dev-dba-subnet" {
  subnet_id      = aws_subnet.dev-db-subnet-a.id
  route_table_id = aws_route_table.dev-db-rt.id
  depends_on     = [aws_route_table_association.dev-internet-gw]
}

resource "aws_route_table_association" "dev-dbb-subnet" {
  subnet_id      = aws_subnet.dev-db-subnet-b.id
  route_table_id = aws_route_table.dev-db-rt.id
  depends_on     = [aws_route_table_association.dev-internet-gw]
}

# backend
resource "aws_route_table_association" "prod-backenda-subnet" {
  subnet_id      = aws_subnet.backend-subnet-a.id
  route_table_id = aws_route_table.prod-backend-rt.id
  depends_on     = [aws_route_table_association.prod-internet-gw]
}

resource "aws_route_table_association" "prod-backendb-subnet" {
  subnet_id      = aws_subnet.backend-subnet-b.id
  route_table_id = aws_route_table.prod-backend-rt.id
  depends_on     = [aws_route_table_association.prod-internet-gw]
}

# dev backend
resource "aws_route_table_association" "dev-backenda-subnet" {
  subnet_id      = aws_subnet.dev-backend-subnet-a.id
  route_table_id = aws_route_table.dev-backend-rt.id
  depends_on     = [aws_route_table_association.dev-internet-gw]
}

resource "aws_route_table_association" "dev-backendb-subnet" {
  subnet_id      = aws_subnet.dev-backend-subnet-b.id
  route_table_id = aws_route_table.dev-backend-rt.id
  depends_on     = [aws_route_table_association.dev-internet-gw]
}

# frontend
resource "aws_route_table_association" "prod-frontenda-subnet" {
  subnet_id      = aws_subnet.frontend-subnet-a.id
  route_table_id = aws_route_table.prod-frontend-rt.id
  depends_on     = [aws_route_table_association.prod-internet-gw]
}

resource "aws_route_table_association" "prod-frontendb-subnet" {
  subnet_id      = aws_subnet.frontend-subnet-b.id
  route_table_id = aws_route_table.prod-frontend-rt.id
  depends_on     = [aws_route_table_association.prod-internet-gw]
}

# dev frontend
resource "aws_route_table_association" "dev-frontenda-subnet" {
  subnet_id      = aws_subnet.dev-frontend-subnet-a.id
  route_table_id = aws_route_table.dev-frontend-rt.id
  depends_on     = [aws_route_table_association.dev-internet-gw]
}

resource "aws_route_table_association" "dev-frontendb-subnet" {
  subnet_id      = aws_subnet.dev-frontend-subnet-b.id
  route_table_id = aws_route_table.dev-frontend-rt.id
  depends_on     = [aws_route_table_association.dev-internet-gw]
}

#mgmt subnet associations
resource "aws_route_table_association" "mgmt-internet" {
  subnet_id      = aws_subnet.mgmt-internet-subnet.id
  route_table_id = aws_route_table.mgmt-internet-rt.id
  depends_on     = [aws_route_table.mgmt-internet-rt]
}

resource "aws_route_table_association" "mgmt-internet-gw" {
  gateway_id     = aws_internet_gateway.mgmt-internet-gw.id
  route_table_id = aws_route_table.mgmt-internet-rt.id
  depends_on     = [aws_route_table_association.mgmt-internet]
}

resource "aws_route_table_association" "mgmt-scanning" {
  subnet_id      = aws_subnet.mgmt-scanning-subnet.id
  route_table_id = aws_route_table.mgmt-scanning-rt.id
  depends_on     = [aws_route_table_association.mgmt-internet-gw]
}


# resource "aws_route_table_association" "prod-nat-gw" {
#   gateway_id = aws_nat_gateway.prod-nat-gw.id
#   route_table_id = aws_route_table.prod-internet-rt.id
#   depends_on = [ aws_route_table_association.prod-internet-gw ]
# }

