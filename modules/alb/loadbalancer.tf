###Load Balancer###
resource "aws_lb" "this" {

  name               = format("%s-%s", var.lb_name, var.env)
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = tolist([aws_security_group.this.id])
  subnets            = var.lb_subnets

  tags = merge(
    {
      "Name"        = format("%s-%s", var.lb_name, var.env)
      "Region"      = format("%s", var.region),
      "Application" = format("%s", var.application_tag)
    },
    var.tags,
  )
}

resource "aws_security_group" "this" {
  name        = format("%s-%s-sg", var.lb_name, var.env)
  description = format("Security group for %s-%s", var.lb_name, var.env)
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = format("%s-%s-sg", var.lb_name, var.env)
    },
    var.tags,
  )
}


resource "aws_security_group_rule" "this_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
