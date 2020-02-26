#!/bin/bash

if [ -z "$1" ]
 then
   echo "Please supply atleast inventory filename and optionally playbook.yml file , default play book is playbook.yml. "
   echo "Usage: ./stop-paxata-stack.sh <inventory_file> <optional playbook.yml> (Example: ./stop-paxata-stack.sh inventoty.aws.ec2"
   exit
fi

if [ -z "$2" ]
 then
   playbook_file=playbook.yml
 else
  playbook_file=$2
fi
   inventory_file=$1

echo "Stopping Paxata Core Services\n"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=stop-app-core-service

echo "Stopping Mongo Services\n"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=stop-app-mongo

echo "Stopping Paxata Pipeline Service\n"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=stop-app-pipeline

echo "Stopping Spark Services only applicable for open source spark cluster"
echo "=============================\n"
ansible-playbook -i ${inventory_file} ${playbook_file} --tags=stop-app-spark


echo "Paxata Stack is stopped\n"
