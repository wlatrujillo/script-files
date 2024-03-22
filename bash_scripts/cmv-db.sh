#!/bin/sh
#
#
# This script is to connect to the database of the environment.
# This script takes one argument, the environment name.


DisplayHelp()
{
   # Display Help
   echo
   echo "Help:"
   echo
   echo "This script is to connect to bastion and expose port to connect the database of the environment."
   echo
   echo "Syntax: scriptTemplate <environmentId>"
   echo
   echo "Options:"
   echo
   echo "  -h Print this Help."
   echo "  -i Specify the AWS instanceId."
   echo
   echo "Arguments:"
   echo
   echo "  environmentId: dev | qa | stg"
   echo
   echo "Usage:"
   echo
   echo "  sh $0 dev"
   echo "  sh $0 -i 434de3434343-34 dev"
}

CallAwsSessionManager()
{
    instanceId=$1 
    profile=$2
    localPort=$3
    portdb=3333
    hostdb=master.database.general.cob.cobiscloud.int

    aws ssm start-session --target $instanceId --profile $profile  --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=$localPort,portNumber=$portdb,host=$hostdb"
}



# Get the options
while getopts ":hi:" option; do
   case $option in
      h) # Display Help
         DisplayHelp
         exit;;
      i) # Specify AWS instanceId
         instanceId="$OPTARG"
         ;;
      \?) # Incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $((OPTIND - 1))

# Check if enough arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Error: Invalid number of arguments"
    DisplayHelp
    exit 1
fi

env=$1

case $env in

  'dev')
    account=573946347747
    profile=${account}_COBDeveloper
    localPort=1055
    ;;

  'qa')
    account=566383216324
    profile=${account}_COBSupport
    localPort=1056
    ;;

  *)
    echo 'environment not valid allowed dev qa'
    exit
    ;;
esac

# Validate if the instance id is empty
if [ -z "$instanceId" ]; then
    echo "Instance Id is empty trying to get the instance id from the environment with profile $profile and the tag Name=$env-bastion-*"
    instanceId=$(aws ec2 --profile $profile describe-instances --filters "Name=tag:Name,Values=$env-bastion-*" | grep InstanceId | awk '{ print $2 }' | tr -d '",' | head -n 1)
    echo "Instance Id: $instanceId"
fi  

CallAwsSessionManager "$instanceId" "$profile" "$localPort"

