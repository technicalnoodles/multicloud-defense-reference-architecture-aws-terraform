
# prod
resource "aws_route" "prod-frontend-internet-route" {
  route_table_id         = aws_route_table.prod-frontend-rt.id
  destination_cidr_block = "0.0.0.0/0"
  # gateway_id             = aws_internet_gateway.prod-internet-gw.id
  gateway_id = ciscomcd_service_vpc.service_vpc.transit_gateway_id
  depends_on = [aws_route_table_association.prod-backenda-subnet, aws_route_table_association.prod-backendb-subnet, aws_route_table_association.prod-dba-subnet, aws_route_table_association.prod-dbb-subnet, aws_route_table_association.prod-frontenda-subnet, aws_route_table_association.prod-frontendb-subnet, aws_internet_gateway.prod-internet-gw, ciscomcd_service_vpc.service_vpc, time_sleep.wait_60_seconds]
}


resource "aws_route" "prod-backend-internet-route" {
  route_table_id         = aws_route_table.prod-backend-rt.id
  destination_cidr_block = "0.0.0.0/0"
  # gateway_id             = aws_nat_gateway.prod-nat-gw.id
  gateway_id = ciscomcd_service_vpc.service_vpc.transit_gateway_id
  depends_on = [aws_route_table_association.prod-backenda-subnet, aws_route_table_association.prod-backendb-subnet, aws_route_table_association.prod-dba-subnet, aws_route_table_association.prod-dbb-subnet, aws_route_table_association.prod-frontenda-subnet, aws_route_table_association.prod-frontendb-subnet, aws_internet_gateway.prod-internet-gw, ciscomcd_service_vpc.service_vpc, time_sleep.wait_60_seconds]
}

# dev
resource "aws_route" "dev-frontend-internet-route" {
  route_table_id         = aws_route_table.dev-frontend-rt.id
  destination_cidr_block = "0.0.0.0/0"
  # gateway_id             = aws_internet_gateway.dev-internet-gw.id
  gateway_id = ciscomcd_service_vpc.service_vpc.transit_gateway_id
  depends_on = [aws_route_table_association.dev-backenda-subnet, aws_route_table_association.dev-backendb-subnet, aws_route_table_association.dev-dba-subnet, aws_route_table_association.dev-dbb-subnet, aws_route_table_association.dev-frontenda-subnet, aws_route_table_association.dev-frontendb-subnet, aws_internet_gateway.dev-internet-gw, ciscomcd_service_vpc.service_vpc, time_sleep.wait_60_seconds]
}


resource "aws_route" "dev-backend-internet-route" {
  route_table_id         = aws_route_table.dev-backend-rt.id
  destination_cidr_block = "0.0.0.0/0"
  # gateway_id             = aws_nat_gateway.dev-nat-gw.id
  gateway_id = ciscomcd_service_vpc.service_vpc.transit_gateway_id
  depends_on = [aws_route_table_association.dev-backenda-subnet, aws_route_table_association.dev-backendb-subnet, aws_route_table_association.dev-dba-subnet, aws_route_table_association.dev-dbb-subnet, aws_route_table_association.dev-frontenda-subnet, aws_route_table_association.dev-frontendb-subnet, aws_internet_gateway.dev-internet-gw, ciscomcd_service_vpc.service_vpc, time_sleep.wait_60_seconds]
}
#mgmt routes
resource "aws_route" "mgmt-internet-route" {
  route_table_id         = aws_route_table.mgmt-scanning-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mgmt-internet-gw.id
  depends_on             = [aws_route_table_association.mgmt-scanning]
}

resource "aws_ec2_transit_gateway_route_table_association" "mgmt-tgw-rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mgmt-to-mgmt-tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.mgmt-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "prod-tgw-rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod-to-mgmt-tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.mgmt-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route" "mgmt-to-prod" {
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod-to-mgmt-tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.mgmt-tgw-rt.id
}

resource "aws_ec2_transit_gateway_route" "prod-to-mgmt" {
  destination_cidr_block         = "10.100.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.mgmt-to-mgmt-tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.mgmt-tgw-rt.id
}


# resource "aws_ec2_transit_gateway_route" "prod-tgw-default" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod-tgw-attachment.id
#   # transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_tabl
#   transit_gateway_route_table_id = "tgw-rtb-0cbc93dffc01662c1"
#   depends_on = [ aws_ec2_transit_gateway.prod-tgw, ciscomcd_service_vpc.service_vpc ]
# }