#!/bin/sh
# This script gets the instance id, instance type, public ip, private ip, and availability zone of the instance
# and prints it to the console

DisplayHelp()
{
   # Display Help
   echo
   echo "Help:"
   echo
   echo "Get the instance id, instance type, public ip, private ip, and availability zone of the instance and print it to the console"
   echo
   echo "Syntax: scriptTemplate [-p profile] [-h] <instance_name> <property>"
   echo
   echo "Options:"
   echo "  -p    Specify the AWS profile."
   echo "  -h    Print this Help."
   echo
   echo "Arguments:"
   echo "  Usage example: $0 mongodb PublicIpAddress"
   echo "  Usage example: $0 mongodb PrivateIpAddress"
   echo "  Usage example: $0 mongodb InstanceId"
   echo "  Usage example: $0 mongodb InstanceType"
}

CallAwsCli()
{
    if [ ! "$1" ] || [ ! "$2" ];
    then
        echo "Error: Invalid arguments profile: $1 name: $2"
        DisplayHelp
        exit 1
    fi

    if [ ! "$3" ];
    then
        aws ec2 --profile "$1" describe-instances --filters "Name=tag:Name,Values=$2"
        exit 0
    fi

    aws ec2 --profile "$1" describe-instances --filters "Name=tag:Name,Values=$2" | grep "$3" | awk '{ print $2 }' | tr -d '",' | head -n 1
}

# Set default profile
profile="wladi.trujillo"

# Get the options
while getopts ":hp:" option; do
   case $option in
      h) # Display Help
         DisplayHelp
         exit;;
      p) # Specify AWS profile
         profile="$OPTARG"
         ;;
      \?) # Incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $((OPTIND - 1))

# Check if enough arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments"
    DisplayHelp
    exit 1
fi

# Call AWS CLI function
CallAwsCli "$profile" "$1" "$2"
