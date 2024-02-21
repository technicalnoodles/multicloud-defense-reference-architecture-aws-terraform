# prod route tables
resource "aws_route_table" "prod-db-rt" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-db-rt"
  }
  depends_on = [aws_nat_gateway.prod-nat-gw]
}

resource "aws_route_table" "prod-backend-rt" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-backend-rt"
  }
  depends_on = [aws_nat_gateway.prod-nat-gw]
}

resource "aws_route_table" "prod-internet-rt" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-internet-rt"
  }
  depends_on = [aws_nat_gateway.prod-nat-gw]
}

resource "aws_route_table" "prod-frontend-rt" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-frontend-rt"
  }
  depends_on = [aws_nat_gateway.prod-nat-gw]
}

#dev route tables
resource "aws_route_table" "dev-db-rt" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-db-rt"
  }
  depends_on = [aws_nat_gateway.dev-nat-gw]
}

resource "aws_route_table" "dev-backend-rt" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-backend-rt"
  }
  depends_on = [aws_nat_gateway.dev-nat-gw]
}

resource "aws_route_table" "dev-internet-rt" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-internet-rt"
  }
  depends_on = [aws_nat_gateway.dev-nat-gw]
}

resource "aws_route_table" "dev-frontend-rt" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-frontend-rt"
  }
  depends_on = [aws_nat_gateway.dev-nat-gw]
}

#mgmt route tables
resource "aws_route_table" "mgmt-internet-rt" {
  vpc_id = aws_vpc.mgmt.id

  tags = {
    Name = "mgmt-internet-rt"
  }
  depends_on = [aws_internet_gateway.mgmt-internet-gw]
}

resource "aws_route_table" "mgmt-scanning-rt" {
  vpc_id = aws_vpc.mgmt.id

  tags = {
    Name = "mgmt-scanning-rt"
  }
  depends_on = [aws_internet_gateway.mgmt-internet-gw]
}

#tgw route tables
resource "aws_ec2_transit_gateway_route_table" "mgmt-tgw-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.mgmt-tgw.id
  depends_on         = [aws_ec2_transit_gateway.mgmt-tgw]
}
#need to change to mcd tgw
# resource "aws_ec2_transit_gateway_route_table" "prod-security-tgw-rt" {
#   transit_gateway_id = aws_ec2_transit_gateway.prod-tgw.id
#   depends_on = [aws_ec2_transit_gateway.prod-tgw] 
# }


#need to change to mcd tgw
# resource "aws_ec2_transit_gateway_vpc_attachment" "prod-tgw-attachment" {
#   subnet_ids         = [aws_subnet.frontend-subnet-a.id, aws_subnet.frontend-subnet-b.id]
#   transit_gateway_id = ciscomcd_service_vpc.prod_service_vpc.transit_gateway_id
#   vpc_id             = aws_vpc.prod.id
#   # depends_on = [aws_ec2_transit_gateway.prod-tgw]
# }