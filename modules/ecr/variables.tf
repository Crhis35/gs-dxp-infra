variable "repo_name" {
  description = "ECR registry Name"
  type        = string
}

variable "create_policy" {
  type    = bool
  default = false
}
