#wait for mcd onboarding timer
resource "time_sleep" "wait_for_aws_onboarding" {
  depends_on = [
    aws_iam_role.ciscomcd_controller_role, aws_iam_role_policy.ciscomcd_controller_policy, ciscomcd_cloud_account.aws1, aws_ec2_transit_gateway.app-tgw
  ]
  create_duration = "60s"
}

#mcd security vpc
resource "ciscomcd_service_vpc" "service_vpc" {
  name               = "security-vpc"
  csp_account_name   = var.ciscomcd_aws_cloud_account_name
  region             = var.region
  cidr               = "10.200.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2c", "us-west-2d"]
  transit_gateway_id = aws_ec2_transit_gateway.app-tgw.id
  use_nat_gateway    = true
  depends_on         = [aws_ec2_transit_gateway.app-tgw, aws_iam_role_policy.ciscomcd_controller_policy, aws_iam_role.ciscomcd_controller_role, time_sleep.wait_for_aws_onboarding]
}

#create spoke attachment
resource "ciscomcd_spoke_vpc" "ciscomcd_spoke" {
  service_vpc_id = ciscomcd_service_vpc.service_vpc.id
  spoke_vpc_id   = aws_vpc.prod.id
  depends_on     = [ciscomcd_service_vpc.service_vpc]
}

resource "ciscomcd_spoke_vpc" "ciscomcd_spoke_dev" {
  service_vpc_id = ciscomcd_service_vpc.service_vpc.id
  spoke_vpc_id   = aws_vpc.dev.id
  depends_on     = [ciscomcd_service_vpc.service_vpc]
}
#creates policy
resource "ciscomcd_policy_rule_set" "ingress_policy_standalone" {
  name = "ingress_rule_set_standalone"
}

# resource "ciscomcd_policy_rule_set" "dev-ingress_policy_standalone" {
#   name = "dev-ingress_rule_set_standalone"
# }

resource "ciscomcd_policy_rule_set" "egress_policy_standalone" {
  name = "egress_rule_set_standalone"
}

# resource "ciscomcd_policy_rule_set" "dev-egress_policy_standalone" {
#   name = "dev-egress_rule_set_standalone"
# }

data "ciscomcd_address_object" "any_ag" {
  name = "any"
}

resource "ciscomcd_gateway" "aws_hub_gw1" {
  name                  = "ingress-gw"
  description           = "AWS Gateway 1"
  csp_account_name      = var.ciscomcd_aws_cloud_account_name
  instance_type         = "AWS_M5_LARGE"
  gateway_image         = "23.06-13"
  gateway_state         = "ACTIVE"
  mode                  = "HUB"
  security_type         = "INGRESS"
  policy_rule_set_id    = ciscomcd_policy_rule_set.ingress_policy_standalone.id
  ssh_key_pair          = "safe-demo-oregon"
  aws_iam_role_firewall = aws_iam_role.ciscomcd_fw_role.name
  region                = "us-west-2"
  vpc_id                = ciscomcd_service_vpc.service_vpc.id
}

resource "ciscomcd_gateway" "aws_egress_gw1" {
  name                  = "aws-egress-gw1"
  description           = "AWS Gateway 1"
  csp_account_name      = var.ciscomcd_aws_cloud_account_name
  instance_type         = "AWS_M5_LARGE"
  gateway_image         = "23.06-13"
  gateway_state         = "ACTIVE"
  mode                  = "HUB"
  security_type         = "EGRESS"
  policy_rule_set_id    = ciscomcd_policy_rule_set.egress_policy_standalone.id
  ssh_key_pair          = "safe-demo-oregon"
  aws_iam_role_firewall = aws_iam_role.ciscomcd_fw_role.name
  region                = "us-west-2"
  vpc_id                = ciscomcd_service_vpc.service_vpc.id
  aws_gateway_lb        = true
}

# egress rule
resource "ciscomcd_service_object" "tcp_internet_access" {
  name         = "tcp_internet_access"
  description  = "allows tcp ports to internet."
  service_type = "Forwarding"
  protocol     = "TCP"
  source_nat   = true
  port {
    destination_ports = "0-65535"
  }
}

resource "ciscomcd_service_object" "udp_internet_access" {
  name         = "udp-internet-access"
  description  = "udp access"
  service_type = "Forwarding"
  protocol     = "UDP"
  source_nat   = true
  port {
    destination_ports = "0-65535"
  }
}


resource "ciscomcd_policy_rules" "egress-ew-policy-rules" {
  rule_set_id = ciscomcd_policy_rule_set.egress_policy_standalone.id
  rule {
    name    = "tcp-out"
    action  = "Allow Log"
    state   = "ENABLED"
    service = ciscomcd_service_object.tcp_internet_access.id
    type    = "Forwarding"
  }

  rule {
    name    = "udp-out"
    action  = "Allow Log"
    state   = "ENABLED"
    service = ciscomcd_service_object.udp_internet_access.id
    type    = "Forwarding"
  }
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on      = [ciscomcd_spoke_vpc.ciscomcd_spoke, ciscomcd_policy_rules.egress-ew-policy-rules]
}