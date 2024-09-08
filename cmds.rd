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
sudo apt-get install jenkins -y

http://IP:8080/
======================================================
Terraform install
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install terraform -y
terraform --version
========================================================
Create IAM Role S3 and EC2 and attach role to jenkins ec2
=========================================================================
Jenkins Config Pipeline
1. This project is parameterized
    choices
      action
        plan
        apply
        destroy
2. For Public github repo credetials not required
==========================================================

<img src="images.png" alt="Description of image" width="300"/>