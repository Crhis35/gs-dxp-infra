module "ecs" {
  source        = "./modules/ecs"
  env           = var.env
  cluster_names = var.repo_names
  depends_on = [
    module.ecr
  ]
}
