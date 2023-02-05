###ECS Cluster###
resource "aws_ecs_cluster" "this" {
  count = length(var.cluster_names)
  name  = format("%s-%s", element(var.cluster_names, count.index), var.env)
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count        = length(aws_ecs_cluster.this)
  cluster_name = element(aws_ecs_cluster.this, count.index).name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }

  depends_on = [
    aws_ecs_cluster.this
  ]

}

###ECS Cluster End###
