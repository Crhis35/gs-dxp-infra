###Target Groups###
resource "aws_lb_target_group" "this" {
  name     = format("%s-%s", var.name, var.env)
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  lifecycle {
    create_before_destroy = true
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

  lifecycle {
    create_before_destroy = true
  }

}
