
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}


##########Jenkins SSH Private Key
output "jenkins-gs-us-east_private_key" {
  description = "Private key for the bjs-jenkins-us-west"
  value       = tls_private_key.jenkins-growth-service.private_key_pem
  sensitive   = true
}


##########Bastion SSH Private Key
output "bastion-gs-us-east_private_key" {
  description = "Private key for the bastion-bjs-us-west"
  value       = tls_private_key.bastion-gs-us-east.private_key_pem
  sensitive   = true
}
################Endpoints

output "jenkins_ip" {
  value       = module.jenkins.public_dns
  description = "Jenkins IP Address"
}

output "bastion_ip" {
  value       = aws_eip.bastion.public_ip
  description = "Jenkins IP Address"
}
