module "jenkins" {
  source               = "./modules/ec2_instance/"
  env                  = var.env
  vpc_id               = module.vpc.vpc_id
  aws_ami_id           = var.jenkins.aws_ami_id
  instance_name        = format("%s-1", var.jenkins.instance_name)
  instance_type        = var.jenkins.instance_type
  key_name             = aws_key_pair.jenkins-growth-service.key_name
  iam_instance_profile = aws_iam_instance_profile.gs_jenkins.name
  public_ip            = var.jenkins.public_ip
  volume_type          = var.jenkins.volume_type
  volume_size          = var.jenkins.volume_size
  ingress_cidr_blocks  = compact(split(",", "${var.jenkins.ingress_cidr_blocks},${var.cidr}"))
  subnets              = module.vpc.public_subnets[0]
  script_name          = var.jenkins.script_name
  tags                 = var.tags
}

resource "aws_eip" "jenkins" {
  instance = module.jenkins.instance_id
  vpc      = true
}
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.jenkins.security_group_id
}

resource "aws_security_group_rule" "host" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.jenkins.security_group_id
}
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.jenkins.security_group_id
}

resource "aws_security_group_rule" "sh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.jenkins.security_group_id
}

resource "aws_lb_target_group" "master_tg" {
  name = "${var.application}-master-tg"

  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = module.vpc.vpc_id
  deregistration_delay = 30

  health_check {
    port                = "traffic-port"
    path                = "/login"
    timeout             = 25
    healthy_threshold   = 2
    unhealthy_threshold = 4
    matcher             = "200-299"
  }

  tags = var.tags
}
resource "aws_lb" "lb" {
  name                       = "${var.application}-lb"
  idle_timeout               = 60
  internal                   = false
  security_groups            = [module.jenkins.security_group_id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_listener" "master_lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.gs_dev_acm.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.master_tg.arn
  }
}

resource "aws_lb_listener" "master_http_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
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

resource "aws_lb_target_group_attachment" "master_lb_attach" {
  target_group_arn = aws_lb_target_group.master_tg.arn
  target_id        = module.jenkins.instance_id
}


