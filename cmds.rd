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
