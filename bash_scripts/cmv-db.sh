#!/bin/sh
#
#
env=$1
echo "environment: $env"
if [ "$env" = "" ]
then
  echo "environment is required example: $0 dev"
  exit
fi

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

portdb=3333
hostdb=master.database.general.CMV.cobiscloud.int

instanceId=$(aws ec2 --profile $profile describe-instances --filters "Name=tag:Name,Values=$env-bastion-*" | grep InstanceId | awk '{ print $2 }' | tr -d '",' | head -n 1)

echo 'instanceId:' $instanceId
if [ "$instanceId" = "" ]
then
echo "instanceId is required but not was found!!"
exit
fi 

echo 'Opening tunel' $env
aws ssm start-session --target $instanceId --profile $profile  --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=$localPort,portNumber=$portdb,host=$hostdb"
