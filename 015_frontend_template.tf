data "aws_ami" "amzn-linux-ami-front" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al*-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "prod-frontend-template" {
  name = "prod-frontend-template"

  iam_instance_profile {
    name = "safe-demo-ec2-bucket-role"
  }

  image_id = data.aws_ami.amzn-linux-ami-front.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.medium"

  key_name = var.ssh_key_name

  # network_interfaces {
  #   associate_public_ip_address = true
  #   security_groups             = [aws_security_group.tshoot.id]
  # }

  monitoring {
    enabled = true
  }


  vpc_security_group_ids = [aws_security_group.tshoot.id]
  tags                   = { Name = "frontend" }
  user_data              = base64encode(templatefile("prod_frontend_setup.tpl", { backend_lb = aws_lb.backend-lb.dns_name, secure_workload_installer = var.secure_workload_installer }))
  depends_on             = [aws_lb.backend-lb]
}

#dev

resource "aws_launch_template" "dev-frontend-template" {
  name = "dev-frontend-template"

  iam_instance_profile {
    name = "safe-demo-ec2-bucket-role"
  }

  image_id = data.aws_ami.amzn-linux-ami-front.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.medium"

  key_name = var.ssh_key_name

  # network_interfaces {
  #   associate_public_ip_address = true
  #   security_groups             = [aws_security_group.tshoot.id]
  # }

  monitoring {
    enabled = true
  }


  vpc_security_group_ids = [aws_security_group.dev-tshoot.id]
  tags                   = { Name = "dev-frontend" }
  user_data              = base64encode(templatefile("dev_frontend_setup.tpl", { backend_lb = aws_lb.dev-backend-lb.dns_name, secure_workload_installer = var.secure_workload_installer }))
  depends_on             = [aws_lb.dev-backend-lb]
}
