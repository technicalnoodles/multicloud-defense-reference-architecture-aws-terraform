#prod

resource "aws_lb" "backend-lb" {
  name               = "backend-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tshoot.id]
  subnets            = [aws_subnet.backend-subnet-a.id, aws_subnet.backend-subnet-b.id]

  enable_deletion_protection = false


  #   access_logs {
  #     bucket  = aws_s3_bucket.ciscomcd_s3_bucket.id
  #     prefix  = "backend-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "production"
  }
  depends_on = [aws_docdb_cluster_instance.cluster_instances]
}

resource "aws_lb_target_group" "backend-target-group" {
  name        = "backend-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.prod.id
}

resource "aws_lb_listener" "backend-listener" {
  load_balancer_arn = aws_lb.backend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-target-group.arn
  }
  depends_on = [aws_lb_target_group.backend-target-group]
}

#dev
resource "aws_lb" "dev-backend-lb" {
  name               = "dev-backend-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev-tshoot.id]
  subnets            = [aws_subnet.dev-backend-subnet-a.id, aws_subnet.dev-backend-subnet-b.id]

  enable_deletion_protection = false


  #   access_logs {
  #     bucket  = aws_s3_bucket.ciscomcd_s3_bucket.id
  #     prefix  = "dev-backend-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "dev"
  }
  depends_on = [aws_docdb_cluster_instance.cluster_instances]
}

resource "aws_lb_target_group" "dev-backend-target-group" {
  name        = "dev-backend-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev.id
}

resource "aws_lb_listener" "dev-backend-listener" {
  load_balancer_arn = aws_lb.dev-backend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-backend-target-group.arn
  }
  depends_on = [aws_lb_target_group.dev-backend-target-group]
}