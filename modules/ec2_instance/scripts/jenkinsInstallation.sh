#!/bin/bash

#Install GIT
sudo yum groupinstall "Development Tools" -y

#Install Docker
sudo yum install docker -y
sudo service docker start

#Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

sudo amazon-linux-extras install java-openjdk11 -y

sudo yum install jenkins -y

#Adding permission to access docker deamon
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins

#Assign shell to Jenkins
sudo usermod --shell /bin/bash jenkins

#Start Jenkins
sudo systemctl start jenkins
