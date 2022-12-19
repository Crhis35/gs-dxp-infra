module "bastion" {
  source               = "./modules/ec2_instance/"
  env                  = var.env
  aws_ami_id           = var.bastion.aws_ami_id
  vpc_id               = module.vpc.vpc_id
  instance_name        = format("%s-1", var.bastion.instance_name)
  instance_type        = var.bastion.instance_type
  key_name             = aws_key_pair.bastion-gs-us-east.key_name
  iam_instance_profile = aws_iam_instance_profile.gs_bastion.name
  public_ip            = var.bastion.public_ip
  volume_type          = var.bastion.volume_type
  volume_size          = var.bastion.volume_size
  ingress_cidr_blocks  = compact(split(",", "${var.bastion.ingress_cidr_blocks},${var.cidr}"))
  subnets              = module.vpc.public_subnets[0]
  script_name          = var.bastion.script_name
  tags                 = var.tags
}

resource "aws_eip" "bastion" {
  instance = module.bastion.instance_id
  vpc      = true
}
