variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "tg_arn" {
  type = string
}

variable "lb_arn" {
  type = string
}

variable "port" {
  type = string
}

variable "protocol" {
  type = string
}
