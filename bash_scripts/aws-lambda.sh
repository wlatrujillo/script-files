#!/bin/sh

# This script is used to invoke AWS Lambda function using AWS CLI 
# The script takes 2 arguments:
# 1. group: the name of the group of EC2 instances to start or stop 
# 2. action: the action to perform on the group of EC2 instances (start or stop) 

DisplayHelp()
{
   # Display Help
   echo
   echo "Help:"
   echo
   echo "This script is used to invoke AWS Lambda function using AWS CLI."
   echo
   echo "Syntax: scriptTemplate <instance_name> <action>"
   echo
   echo "Options:"
   echo "  -p    Specify the AWS profile."
   echo "  -h    Print this Help."
   echo
   echo "Arguments:"
   echo "  Usage example: $0 mongodb start"
   echo "  Usage example: $0 mongodb stop"
}

CallAwsCli()
{
  aws lambda --profile $1 invoke --function-name start_stop_ec2 --cli-binary-format raw-in-base64-out --payload '{"tag":"Name", "value":"'$2'", "action":"'$3'"}' --region us-east-1 out.txt
}

# Initialize the profile
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

name=$1
action=$2

# Check if the action is valid
if [ "$action" != "start" ] && [ "$action" != "stop" ]; then
    echo "Error: Invalid action"
    DisplayHelp
    exit 1
fi

# Check if the profile is provided
if [ -z "$profile" ]; then
    echo "Error: AWS profile is not provided"
    DisplayHelp
    exit 1
fi

# Call the AWS CLI
CallAwsCli $profile $name $action
