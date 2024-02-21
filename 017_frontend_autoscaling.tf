resource "aws_autoscaling_group" "frontend-autoscaling-group" {
  vpc_zone_identifier       = [aws_subnet.frontend-subnet-a.id, aws_subnet.frontend-subnet-b.id]
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  force_delete              = true
  health_check_grace_period = 500
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.frontend-target-group.arn]

  launch_template {
    id      = aws_launch_template.prod-frontend-template.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.prod-frontend-template, aws_lb.frontend-lb]
}

# resource "aws_autoscaling_attachment" "backend-lb-as-atachment" {
#   autoscaling_group_name = aws_autoscaling_group.backend-autoscaling-group.id

#   depends_on = [ aws_autoscaling_group.backend-autoscaling-group ]
# }

#dev
resource "aws_autoscaling_group" "dev-frontend-autoscaling-group" {
  vpc_zone_identifier       = [aws_subnet.dev-frontend-subnet-a.id, aws_subnet.dev-frontend-subnet-b.id]
  desired_capacity          = 1
  max_size                  = 3
  min_size                  = 1
  force_delete              = true
  health_check_grace_period = 500
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.dev-frontend-target-group.arn]

  launch_template {
    id      = aws_launch_template.dev-frontend-template.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.dev-frontend-template, aws_lb.dev-frontend-lb]
}