###Target Groups###
resource "aws_lb_target_group" "this" {
  name     = format("%s-%s", var.name, var.env)
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id


  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    path                = var.path
  }

  tags = merge(
    {
      "Name"        = format("%s-%s", var.name, var.env)
      "Region"      = format("%s", var.region),
      "Application" = format("%s", var.application_tag)
    },
    var.tags,
  )
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = var.lb_arn
  port              = var.listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

}
###Target Groups End###
