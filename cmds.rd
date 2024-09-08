ssh-keygen -t ed25519 -C "<comment>"
=======================================
eval $(ssh-agent -s)
ssh-add .ssh/id_ed25519
========================================
Save these settings in the ~/.ssh/config file. For example:
Host gitlab.com
  User git
  Hostname gitlab.com
  IdentityFile ~/.ssh/id_ed25519
=========================================
ssh -T git@gitlab.com                 

Welcome to GitLab, @org-navinku!
===========================================
git clone git@gitlab.com:org-navinku/tf-aws.git
=================================================
aws configure
set accesskey and password in cat ~/.aws/credentials
[default]
aws_access_key_id = 
aws_secret_access_key = 
region in cat ~/.aws/config
region = us-east-1
output = json
==================================================
Jenkins -- https://www.jenkins.io/doc/book/installing/linux/
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

http://IP:8080/
======================================================
sudo docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1