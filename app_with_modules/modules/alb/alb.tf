
# Create security_group for alb
resource "aws_security_group" "sg_alb" {
  name        = "${var.app_name}-${var.environment_name}-alb-security-group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "allow alb traffic ${var.app_name}-${var.environment_name}"
  }
}


resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_alb.id

  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.sg_alb.id

  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks         = ["0.0.0.0/0"]

}

# Create alb
resource "aws_lb" "load_balancer" {
  name               = "${var.app_name}-${var.environment_name}-web-app-lb"
  load_balancer_type = "application"
  subnets            = "${var.public_subnet_ids[*]}"
  security_groups    = [aws_security_group.sg_alb.id]

}


# Create listener for load balalancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port = 80

  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.frontend.arn}"
  }
}


# Create target group 
resource "aws_lb_target_group" "frontend" {
  name     = "${var.app_name}-${var.environment_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create listener rule 
resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

# Create targets 
resource "aws_lb_target_group_attachment" "frontend" {
  count             = length(var.frontend_ids)
  target_group_arn  = aws_lb_target_group.frontend.arn
  target_id         = var.frontend_ids[count.index]
  port              = 80
}


