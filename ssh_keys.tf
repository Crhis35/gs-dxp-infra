
#Jenkins KeyPair Generation
resource "tls_private_key" "jenkins-growth-service" {
  algorithm = "RSA"
}

resource "aws_key_pair" "jenkins-growth-service" {
  key_name   = "gs-jenkins-us-east-1"
  public_key = tls_private_key.jenkins-growth-service.public_key_openssh
}

#Bastion KeyPair Generation
resource "tls_private_key" "bastion-gs-us-east" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion-gs-us-east" {
  key_name   = "gss-bastion-us-east-1"
  public_key = tls_private_key.bastion-gs-us-east.public_key_openssh
}
