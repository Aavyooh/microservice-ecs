resource "aws_lb_target_group" "wp_tg" {
  name        = "dev-wp-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "dev-wp-tg"
  }
}



######################## alb ############################

resource "aws_lb" "wp_alb" {
  name               = "${var.environment}-wp-alb"
  load_balancer_type = "application"
  internal           = false                    # Internet facing

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-wp-alb"
  }
}
####################### ALB Listener ###########################

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_tg.arn
  }
}
