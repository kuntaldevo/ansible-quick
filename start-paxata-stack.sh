#!/bin/bash

if [ -z "$1" ]
 then
   echo "Please supply atleast inventory filename and optionally playbook.yml file , default play book is playbook.yml. "
   echo "Usage: ./start-paxata-stack.sh <inventory_file> <optional playbook.yml> (Example: ./start-paxata-stack.sh inventoty.aws.ec2"
   exit
fi

if [ -z "$2" ]
 then
   playbook_file=playbook.yml
 else
  playbook_file=$2
fi
   inventory_file=$1

echo "Starting Spark Services only applicable for open source spark cluster"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=start-app-spark

echo "Starting Paxata Pipeline Service\n"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=start-app-pipeline

echo "Starting Mongo Services\n"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=start-app-mongo

echo "Starting Paxata Core Services\n"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=start-app-core-service

echo "Paxata Stack is started\n"
