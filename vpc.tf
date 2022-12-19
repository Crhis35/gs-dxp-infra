module "vpc" {
  source                  = "./modules/vpc/"
  name                    = var.name
  env                     = var.env
  cidr                    = var.cidr
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch
  azs                     = var.azs
  tags                    = var.tags
  public_eks_tags = merge({
    format("kubernetes.io/cluster/%s-%s", var.eks_cluster_name, var.env) = "shared"
  }, var.public_eks_tags)
  private_eks_tags = merge({
    format("kubernetes.io/cluster/%s-%s", var.eks_cluster_name, var.env) = "shared"
  }, var.private_eks_tags)
}
