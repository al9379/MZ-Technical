resource "aws_lb" "application_load_balancer" {
  name               = "megazone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id

  enable_deletion_protection = false

  tags = {
    Name = "Megazone-ALB"
  }
}

resource "aws_lb_target_group" "app_tier" {
  name     = "app-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.megazone_vpc.id

  tags = {
    Name = "App-Tier-Target-Group"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
