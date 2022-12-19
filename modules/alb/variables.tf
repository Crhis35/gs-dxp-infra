variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "lb_name" {
  description = "Name of the Loadbalancer"
  type        = string
}

variable "internal" {
  type = bool
}

variable "lb_type" {
  description = "Type of the Loadbalancer"
  type        = string
}

variable "lb_subnets" {
  description = "Subnets assocaited to Loadbalancer"
  type        = list(string)
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "application_tag" {
  type = string
}

variable "region" {
  type = string
}
