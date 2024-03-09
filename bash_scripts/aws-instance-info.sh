#!/bin/sh
# This script will get the instance id, instance type, public ip, private ip, and availability zone of the instance
# and print it to the console

# Usage: ./aws_instance_info.sh <instance_name> <profile> <property>
name=$1
profile=wladi.trujillo
property=PublicIpAddress

aws ec2 --profile $profile describe-instances --filters "Name=tag:Name,Values=$name" | grep $property | awk '{ print $2 }' | tr -d '",' | head -n 1
