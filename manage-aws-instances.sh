#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

usage()
{
   echo "Please supply atleast inventory filename and optionally playbook.yml file , default play book is playbook.yml. "
   echo "Usage: ./manage-instances.sh start|stop <inventory_file> <optional playbook.yml> (Example: ./manage-instances.sh start inventoty.aws.ec2"
}

if [ -z "$2" ]
 then
   usage
   exit
fi


if [ -z "$3" ]
 then
   playbook_file=$SCRIPTPATH/playbook.yml
 else
  playbook_file=$3
fi
   inventory_file=$SCRIPTPATH/$2

instance_action=$1

take_instance_action()
{
    echo "Invoking $1 on $inventory_file inventory"
    export ANSIBLE_HOST_KEY_CHECKING=false;
    case "$1" in
    "start")
 	echo "Calling Start from Managed instances script "
	echo "********************************************"
        ansible-playbook -i $inventory_file $playbook_file --tags=$1-instance
        sh $SCRIPTPATH/$1-paxata-stack.sh $inventory_file $playbook_file
        return 0;;
    "stop")
 	echo "Calling Stop from Managed instances script "
	echo "********************************************"
        sh $SCRIPTPATH/$1-paxata-stack.sh $inventory_file $playbook_file
        ansible-playbook -i $inventory_file $playbook_file --tags=$1-instance
        return 0;;
    *)
        echo "Action $1 is not supported"
        return 1;;
    esac
}



if ! take_instance_action "$instance_action"; then
    echo "Bye."
    exit 1
fi

