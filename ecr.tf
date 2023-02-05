module "ecr" {
  source        = "./modules/ecr"
  for_each      = toset(var.repo_names)
  repo_name     = each.key
  create_policy = true
}
