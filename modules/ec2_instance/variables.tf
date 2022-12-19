variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  type = string
}

variable "env" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnets" {
  type = string
}

variable "public_ip" {
  type = bool
}

variable "instance_name" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = number
}

variable "aws_ami_id" {
  type = string
}

variable "script_name" {
  type = string
}
