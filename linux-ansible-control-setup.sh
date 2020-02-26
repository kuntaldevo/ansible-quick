#!/bin/bash
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
sudo yum update -y
sudo yum -y install ansible
#boto boto3 is AWS dependency
sudo yum -y install boto boto3
sudo yum -y install python-pip
sudo pip install --upgrade pip
sudo pip install --upgrade Jinja2
export ANSIBLE_HOST_KEY_CHECKING=false


