#!/bin/sh
#
#
env=$1
echo "environment: $env"
if [ "$env" = "" ]
then
  echo "environment is required example: $0 dev1"
  exit
fi

case $env in

  'dev1')
    account=681989517074
    profile=${account}_COBDeveloper
    localPort=3315
    ;;

  'qa1')
    account=110595436954
    profile=${account}_COBTester
    localPort=3316
    ;;

  *)
    echo 'environment not valid allowed dev1 qa1'
    exit
    ;;
esac

portdb=3333
hostdb=master.database.general.cob.cobiscloud.int

instanceId=$(aws ec2 --profile $profile describe-instances --filters "Name=tag:Name,Values=$env-bastion-*" | grep InstanceId | awk '{ print $2 }' | tr -d '",' | head -n 1)

echo 'instanceId:' $instanceId
if [ "$instanceId" = "" ]
then
echo "instanceId is required but not was found!!"
exit
fi 

echo 'Opening tunel' $env
aws ssm start-session --target $instanceId --profile $profile  --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=$localPort,portNumber=$portdb,host=$hostdb"
