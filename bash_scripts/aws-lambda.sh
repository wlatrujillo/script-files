#!/bin/sh

# This script is used to invoke AWS Lambda function using AWS CLI 
# The script takes 2 arguments:
# 1. group: the name of the group of EC2 instances to start or stop 
# 2. action: the action to perform on the group of EC2 instances (start or stop) 
group=$1
action=$2

if [ ! "$group" ] || [ ! "$action" ]
then
  echo "group and action is required example: $0 facturero stop"
  exit
fi

payload='{"group": "'$group'","action":"'$action'"}'
echo "Payload: $payload"

aws lambda --profile wladi.trujillo invoke --function-name start_stop_ec2 --cli-binary-format raw-in-base64-out --payload '{"group":"'$group'", "action":"'$action'"}' --region us-east-1 out.txt


