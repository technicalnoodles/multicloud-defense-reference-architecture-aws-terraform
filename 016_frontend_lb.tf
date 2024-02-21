#prod
resource "aws_lb" "frontend-lb" {
  name               = "frontend-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tshoot.id]
  subnets            = [aws_subnet.frontend-subnet-a.id, aws_subnet.frontend-subnet-b.id]

  enable_deletion_protection = false


  #   access_logs {
  #     bucket  = aws_s3_bucket.ciscomcd_s3_bucket.id
  #     prefix  = "backend-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "production"
  }
  depends_on = [aws_docdb_cluster_instance.cluster_instances, aws_lb.backend-lb]
}

resource "aws_lb_target_group" "frontend-target-group" {
  name        = "frontend-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.prod.id
}

resource "aws_lb_listener" "frontend-listener" {
  load_balancer_arn = aws_lb.frontend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-target-group.arn
  }
  depends_on = [aws_lb_target_group.frontend-target-group]
}

#dev
resource "aws_lb" "dev-frontend-lb" {
  name               = "dev-frontend-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev-tshoot.id]
  subnets            = [aws_subnet.dev-frontend-subnet-a.id, aws_subnet.dev-frontend-subnet-b.id]

  enable_deletion_protection = false


  #   access_logs {
  #     bucket  = aws_s3_bucket.ciscomcd_s3_bucket.id
  #     prefix  = "backend-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "production"
  }
  depends_on = [aws_docdb_cluster_instance.cluster_instances, aws_lb.backend-lb]
}

resource "aws_lb_target_group" "dev-frontend-target-group" {
  name        = "dev-frontend-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev.id
}

resource "aws_lb_listener" "dev-frontend-listener" {
  load_balancer_arn = aws_lb.dev-frontend-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-frontend-target-group.arn
  }
  depends_on = [aws_lb_target_group.dev-frontend-target-group]
}