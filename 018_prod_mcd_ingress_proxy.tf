#prod
resource "ciscomcd_address_object" "prod-backend" {
  name            = "prod-backend"
  description     = ""
  type            = "STATIC"
  value           = [aws_lb.frontend-lb.dns_name]
  backend_address = true
  depends_on      = [aws_autoscaling_group.frontend-autoscaling-group]
}

resource "ciscomcd_service_object" "prod-backend" {
  name                  = "prod-backend"
  description           = ""
  service_type          = "ReverseProxy"
  protocol              = "TCP"
  source_nat            = false
  backend_address_group = ciscomcd_address_object.prod-backend.id
  transport_mode        = "HTTP"
  port {
    destination_ports = "80"
    backend_ports     = "80"
  }
  depends_on = [ciscomcd_address_object.prod-backend]
}

#dev
resource "ciscomcd_address_object" "dev-backend" {
  name            = "dev-backend"
  description     = ""
  type            = "STATIC"
  value           = [aws_lb.dev-frontend-lb.dns_name]
  backend_address = true
  depends_on      = [aws_autoscaling_group.dev-frontend-autoscaling-group]
}

resource "ciscomcd_service_object" "dev-backend" {
  name                  = "dev-backend"
  description           = ""
  service_type          = "ReverseProxy"
  protocol              = "TCP"
  source_nat            = false
  backend_address_group = ciscomcd_address_object.dev-backend.id
  transport_mode        = "HTTP"
  port {
    destination_ports = "8080"
    backend_ports     = "80"
  }
  depends_on = [ciscomcd_address_object.dev-backend]
}

#policy

resource "ciscomcd_policy_rules" "ingress-ew-policy-rules" {
  rule_set_id = ciscomcd_policy_rule_set.ingress_policy_standalone.id
  rule {
    name        = "tcp-80"
    description = ""
    action      = "Allow Log"
    state       = "ENABLED"
    service     = ciscomcd_service_object.prod-backend.id
    type        = "ReverseProxy"
  }
  rule {
    name        = "tcp-8080"
    description = "dev-ingress"
    action      = "Allow Log"
    state       = "ENABLED"
    service     = ciscomcd_service_object.dev-backend.id
    type        = "ReverseProxy"
  }
}



# resource "ciscomcd_policy_rules" "dev-ingress-ew-policy-rules" {
#   rule_set_id = ciscomcd_policy_rule_set.ingress_policy_standalone.id
#   rule {
#     name        = "tcp-8080"
#     description = "dev-ingress"
#     action      = "Allow Log"
#     state       = "ENABLED"
#     service     = ciscomcd_service_object.dev-backend.id
#     type        = "ReverseProxy"
#   }
# }
