
resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.lb-sg.id]  # put LB security group id
  ip_address_type    = "ipv4"

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.app_environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name                  = "${var.app_name}-${var.app_environment}-tg"
  port                  = 8080
  protocol              = "HTTP"
  ip_address_type       = "ipv4"
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  protocol_version                  = "HTTP1"
  slow_start                        = "0"
  target_type           = "instance"
  vpc_id                = aws_vpc.aws-vpc.id

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/ping"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
    Environment = var.app_environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

output "load_balancer_public_dns" {
  value = aws_alb.application_load_balancer.dns_name
}