resource "aws_lb" "ecs_envoy_nlb" {
  name               = "${var.nlb_name}"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["subnet-3ff1545b"]

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "front_80" {
  load_balancer_arn = "${aws_lb.ecs_envoy_nlb.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_443" {
  load_balancer_arn = "${aws_lb.ecs_envoy_nlb.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    type = "redirect"

    redirect {
      port        = "80"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}
