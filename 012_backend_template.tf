data "aws_ami" "amzn-linux2-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230926.0-x86_64-gp2"]
  }
}

resource "aws_launch_template" "prod-backend-template" {
  name = "prod-backend-template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  #  network_interfaces {
  #     associate_public_ip_address = true
  #     security_groups = [aws_security_group.tshoot.id]
  #   }

  iam_instance_profile {
    name = "safe-demo-ec2-bucket-role"
  }

  image_id = data.aws_ami.amzn-linux2-ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.medium"

  key_name = var.ssh_key_name

  monitoring {
    enabled = true
  }


  vpc_security_group_ids = [aws_security_group.tshoot.id]

  user_data  = base64encode(templatefile("prod_backend_setup.tpl", { db_endpoint = aws_docdb_cluster.prod-docdb-cluster.endpoint, secure_workload_installer = var.secure_workload_installer, app_to_install_location_s3 = var.app_to_install_location_s3 }))
  tags       = { Name = "backend" }
  depends_on = [aws_docdb_cluster_instance.cluster_instances]
}

# dev
resource "aws_launch_template" "dev-backend-template" {
  name = "dev-backend-template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  #  network_interfaces {
  #     associate_public_ip_address = true
  #     security_groups = [aws_security_group.tshoot.id]
  #   }

  iam_instance_profile {
    name = "safe-demo-ec2-bucket-role"
  }

  image_id = data.aws_ami.amzn-linux2-ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.medium"

  key_name = var.ssh_key_name

  monitoring {
    enabled = true
  }


  vpc_security_group_ids = [aws_security_group.dev-tshoot.id]

  user_data  = base64encode(templatefile("dev_backend_setup.tpl", { db_endpoint = aws_docdb_cluster.dev-docdb-cluster.endpoint, secure_workload_installer = var.secure_workload_installer }))
  tags       = { Name = "backend" }
  depends_on = [aws_docdb_cluster_instance.dev-cluster_instances]
}
