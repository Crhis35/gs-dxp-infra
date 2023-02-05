
############General#######
variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "application" {
  type        = string
  description = "Application name"
}
######VPC############

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route 53 zone id"
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = false
}

variable "private_eks_tags" {
  type    = map(string)
  default = {}
}

variable "public_eks_tags" {
  type    = map(string)
  default = {}
}


variable "jenkins" {
  type = map(any)
}

######ECR Repo Names
variable "repo_names" {
  description = "A list of ecr repo_name"
  type        = list(string)
  default     = []
}

###########EKS#########

variable "eks_cluster_name" {
  type = string
}

#####Bastion
variable "bastion" {
  type = map(any)
}
