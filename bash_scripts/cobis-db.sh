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
   echo "Description: Connect bastion and expose port to connect DB."
   echo
   echo "Syntax: sh cobis-db.sh <customerId> <environmentId>"
   echo
   echo "Options:"
   echo
   echo "  -h Print this Help."
   echo "  -i Specify the AWS instanceId."
   echo
   echo "Arguments:"
   echo
   echo "  customerId: cobis | cmv | clf"
   echo "  environmentId: dev1 | qa1 | stg1"
   echo
   echo "Usage:"
   echo
   echo "  sh $0 cobis dev1"
   echo "  sh $0 -i 434de3434343-34 cobis dev1"
}

CallAwsSessionManager()
{
    instanceId=$1 
    profile=$2
    region=$3
    localPort=$4
    hostdb=$5
    portdb=3333

    echo "aws ssm start-session --target $instanceId --profile $profile --region $region --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters \"localPortNumber=$localPort,portNumber=$portdb,host=$hostdb\""

    aws ssm start-session --target $instanceId --profile $profile --region $region --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=$localPort,portNumber=$portdb,host=$hostdb"
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
if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments"
    DisplayHelp
    exit 1
fi

customer=$1
env=$2

case $customer in 
    
      'cobis')
        case $env in

          'dev1')
            account=681989517074
            profile=COBDeveloper-${account}
            region=us-east-1
            hostdb=master.database.general.cob.cobiscloud.int
            localPort=3315
            ;;
          'dev2')
            account=681989517074
            profile=COBDeveloper-${account}
            region=us-east-1
            hostdb=dev2-us-east-1-gp-cluster-rds-bck-20230921-global.cluster-ck9mgilqxnyv.us-east-1.rds.amazonaws.com
            localPort=3316
            ;;
          'dev3')
            account=681989517074
            profile=COBDeveloper-${account}
            region=us-east-1
            hostdb=dev3-gp-cluster-rds-bck-24112023-dev3.cluster-ck9mgilqxnyv.us-east-1.rds.amazonaws.com
            localPort=3317
            ;;
          'dev4')
            account=681989517074
            profile=COBDeveloper-${account}
            region=us-east-2
            hostdb=master.database.general.cob.cobiscloud.int
            localPort=3318
            ;;
          'dev5')
            account=681989517074
            profile=COBDeveloper-${account}
            region=us-east-2
            hostdb=master.database.general.cob.cobiscloud.int
            localPort=3319
            ;;
          'qa1')
            account=110595436954
            profile=COBSupport-${account}
            region=us-east-1
            hostdb=master.database.general.cob.cobiscloud.int
            localPort=3415
            ;;
          'qa2')
            account=110595436954
            profile=COBSupport-${account}
            region=us-east-1
            hostdb=master.database.general.cob.cobiscloud.int
            localPort=3416
            ;;
          'drqa2')
            account=110595436954
            profile=COBSupport-${account}
            region=us-west-2
            hostdb=drqa2-us-west-2-gp-cluster-rds-bck-20230925-global.cluster-ckkvmm8qhq9z.us-west-2.rds.amazonaws.com
            localPort=3416
            ;;
          'stg1')
            account=891377317704
            profile=COBSupport-${account}
            region=us-east-1
            hostdb=master.database.general.cob.cobiscloud.int
            localPort=3515
            ;;

          *)
            echo 'environment not valid allowed dev1 dev4 dev5 qa1 qa2 drqa2 stg1'
            exit
            ;;
        esac
     ;;
    
      'cmv')
        case $env in

          'dev')
            account=573946347747
            profile=COBDeveloper-${account}
            region=us-east-1
            hostdb=master.database.general.CMV.cobiscloud.int
            localPort=1055
            ;;

          'qa')
            account=566383216324
            profile=COBSupport-${account}
            region=us-east-1
            hostdb=master.database.general.CMV.cobiscloud.int
            localPort=1155
            ;;

          *)
            echo 'environment not valid allowed dev qa'
            exit
            ;;
        esac
     ;;
    
      'clf')
     ;;
    
      *)
     echo 'customer not valid allowed cobis cmv clf'
     exit
     ;;
esac


# Validate if the instance id is empty
if [ -z "$instanceId" ]; then
    echo "Instance Id is empty trying to get the instance id from the environment with profile $profile and the tag Name=$env-bastion-*"
    instanceId=$(aws ec2 --profile $profile --region $region describe-instances --filters "Name=tag:Name,Values=$env-bastion-*" | grep InstanceId | awk '{ print $2 }' | tr -d '",' | head -n 1)
fi  

CallAwsSessionManager "$instanceId" "$profile" "$region" "$localPort" "$hostdb"

