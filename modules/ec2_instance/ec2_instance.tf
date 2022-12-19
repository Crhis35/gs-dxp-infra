data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = file("${path.module}/scripts/${var.script_name}")
  associate_public_ip_address = var.public_ip
  subnet_id                   = var.subnets
  vpc_security_group_ids      = tolist([aws_security_group.this.id])

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  tags = merge(
    {
      "Name" = format("%s-%s", var.instance_name, var.env),
    },
    var.tags,
  )
}

resource "aws_security_group" "this" {
  name        = format("SG-%s-%s", var.instance_name, var.env)
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = format("sg-%s-%s", var.instance_name, var.env)
    },
    var.tags,
  )
}
resource "aws_security_group_rule" "this_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
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
