#prod internet gateway
resource "aws_internet_gateway" "prod-internet-gw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-internet-gw"
  }

  depends_on = [aws_subnet.backend-subnet-a, aws_subnet.backend-subnet-b, aws_subnet.db-subnet-a, aws_subnet.db-subnet-b, aws_subnet.prod-internet-subnet, aws_subnet.frontend-subnet-a, aws_subnet.frontend-subnet-b]
}

#dev internet gateway
resource "aws_internet_gateway" "dev-internet-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-internet-gw"
  }

  depends_on = [aws_subnet.dev-backend-subnet-a, aws_subnet.dev-backend-subnet-b, aws_subnet.dev-db-subnet-a, aws_subnet.dev-db-subnet-b, aws_subnet.dev-internet-subnet, aws_subnet.dev-frontend-subnet-a, aws_subnet.dev-frontend-subnet-b]
}



#elastic IP
resource "aws_eip" "prod-nat-gw-ip" {
  domain = "vpc"

  tags = {
    Name = "prod-nat-gw-ip"
  }

  depends_on = [aws_internet_gateway.prod-internet-gw]
}

# dev elastic IP
resource "aws_eip" "dev-nat-gw-ip" {
  domain = "vpc"

  tags = {
    Name = "dev-nat-gw-ip"
  }

  depends_on = [aws_internet_gateway.dev-internet-gw]
}

#prod nat gateway
resource "aws_nat_gateway" "prod-nat-gw" {
  allocation_id = aws_eip.prod-nat-gw-ip.id
  subnet_id     = aws_subnet.prod-internet-subnet.id

  tags = {
    Name = "prod-nat-gw"
  }

  depends_on = [aws_internet_gateway.prod-internet-gw, aws_eip.prod-nat-gw-ip]
}

#dev nat gateway
resource "aws_nat_gateway" "dev-nat-gw" {
  allocation_id = aws_eip.dev-nat-gw-ip.id
  subnet_id     = aws_subnet.dev-internet-subnet.id

  tags = {
    Name = "dev-nat-gw"
  }

  depends_on = [aws_internet_gateway.dev-internet-gw, aws_eip.dev-nat-gw-ip]
}


resource "aws_ec2_transit_gateway" "app-tgw" {
  description                     = "transit gateway to connect to the mcd security VPC"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  depends_on                      = [aws_internet_gateway.prod-internet-gw, aws_eip.prod-nat-gw-ip, aws_internet_gateway.dev-internet-gw, aws_eip.dev-nat-gw-ip]
}

#mgmt gateways
resource "aws_internet_gateway" "mgmt-internet-gw" {
  vpc_id = aws_vpc.mgmt.id

  tags = {
    Name = "prod-mgmt-gw"
  }

  depends_on = [aws_subnet.mgmt-scanning-subnet, aws_subnet.mgmt-internet-subnet]
}

resource "aws_ec2_transit_gateway" "mgmt-tgw" {
  description                     = "transit gateway to connect to the mgmt VPC"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  depends_on                      = [aws_internet_gateway.mgmt-internet-gw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "mgmt-to-mgmt-tgw" {
  subnet_ids         = [aws_subnet.mgmt-scanning-subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.mgmt-tgw.id
  vpc_id             = aws_vpc.mgmt.id
  depends_on         = [aws_ec2_transit_gateway.mgmt-tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod-to-mgmt-tgw" {
  subnet_ids         = [aws_subnet.backend-subnet-a.id, aws_subnet.backend-subnet-b.id]
  transit_gateway_id = aws_ec2_transit_gateway.mgmt-tgw.id
  vpc_id             = aws_vpc.prod.id
  depends_on         = [aws_ec2_transit_gateway.mgmt-tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "dev-to-mgmt-tgw" {
  subnet_ids         = [aws_subnet.dev-backend-subnet-a.id, aws_subnet.dev-backend-subnet-b.id]
  transit_gateway_id = aws_ec2_transit_gateway.mgmt-tgw.id
  vpc_id             = aws_vpc.dev.id
  depends_on         = [aws_ec2_transit_gateway.mgmt-tgw]
}