# Infra

inside variables/dev.tfvars

```sh
name                    = "growth"
env                     = "dev"
cidr                    = "10.50.0.0/21"
public_subnets          = ["10.50.0.0/26", "10.50.0.64/26"]
private_subnets         = ["10.50.0.128/25", "10.50.1.0/25", "10.50.1.128/25", "10.50.2.0/25"]
map_public_ip_on_launch = "false"
region                  = "us-west-1"
eks_cluster_name        = "growth-service"
zone_id = ""
application = "balancer"

azs = ["us-east-1a", "us-east-1b"]
tags = {
  "Environment" = "Dev",
  "Project"     = "Growth Service"
  "ManagedBy"   = "Crhis-DevOps"
  "CreatedBy"   = "Terraform"
}

#Jenkins
jenkins = {
  aws_ami_id          = "ami-0d08ef957f0e4722b"
  instance_name       = "GS-Jenkins",
  instance_type       = "t2.nano",
  public_ip           = true,
  volume_type         = "gp2",
  volume_size         = 10,
  ingress_cidr_blocks = "167.246.40.40/32,59.144.18.118/32,125.16.91.5/32,14.140.116.145/32"
  script_name         = "jenkinsInstallation.sh"
}

#Bastion Server
bastion = {
  aws_ami_id          = "ami-0d08ef957f0e4722b"
  instance_name       = "BJS-Bastion",
  instance_type       = "t2.nano",
  public_ip           = true,
  volume_type         = "gp2",
  volume_size         = 10,
  ingress_cidr_blocks = "167.246.40.40/32,59.144.18.118/32,125.16.91.5/32,14.140.116.145/32"
  script_name         = "bastion.sh"
}

```
