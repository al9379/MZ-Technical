# Application Load Balancer Configuration
resource "aws_lb" "application_load_balancer" {
  name               = "megazone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "Megazone-ALB"
  }
}

# Target Group to Forward Traffic to
resource "aws_lb_target_group" "app_tier" {
  name     = "app-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_health_state {
    enable_unhealthy_connection_termination = false
  }

  tags = {
    Name = "App-Tier-Target-Group"
  }
}

# Create target group attachment for each private app server here

# Listener for HTTP (port 80)
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tier.arn
  }
}

# Generate a private key
resource "tls_private_key" "example" {
  algorithm = "RSA"
}

# Generate a self signed certificate
resource "tls_self_signed_cert" "example" {
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Megazone Technical"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Import the certificate into ACM
resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.example.private_key_pem
  certificate_body = tls_self_signed_cert.example.cert_pem

  tags = {
    Name = "Megazone-SelfSigned-Cert"
  }
}
