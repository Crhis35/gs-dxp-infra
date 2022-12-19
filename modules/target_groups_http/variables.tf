variable "vpc_id" {
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "env" {
  type = string
}

variable "protocol" {
  type = string
}

variable "name" {
  type = string
}

variable "path" {
  type = string
}

variable "port" {
  type = number
}

variable "listener_port" {
  type = number
}

variable "lb_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "application_tag" {
  type = string
}
