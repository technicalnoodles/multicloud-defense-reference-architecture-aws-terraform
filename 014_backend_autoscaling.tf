resource "aws_autoscaling_group" "backend-autoscaling-group" {
  vpc_zone_identifier       = [aws_subnet.backend-subnet-a.id, aws_subnet.backend-subnet-b.id]
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  force_delete              = true
  health_check_grace_period = 500
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.backend-target-group.arn]

  launch_template {
    id      = aws_launch_template.prod-backend-template.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.prod-backend-template, aws_lb.backend-lb]
}

# resource "aws_autoscaling_attachment" "backend-lb-as-atachment" {
#   autoscaling_group_name = aws_autoscaling_group.backend-autoscaling-group.id

#   depends_on = [ aws_autoscaling_group.backend-autoscaling-group ]
# }

#dev
resource "aws_autoscaling_group" "dev-backend-autoscaling-group" {
  vpc_zone_identifier       = [aws_subnet.dev-backend-subnet-a.id, aws_subnet.dev-backend-subnet-b.id]
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  force_delete              = true
  health_check_grace_period = 500
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.dev-backend-target-group.arn]

  launch_template {
    id      = aws_launch_template.dev-backend-template.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.dev-backend-template, aws_lb.dev-backend-lb]
}