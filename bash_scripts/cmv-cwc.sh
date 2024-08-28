#!/bin/sh
#
env=$1
imageTag=$2

if [ ! "$env" ] || [ ! "$imageTag" ]
then
  echo "environment and imageTag is required example: $0 dev cmv-dev-cwc-v1.11.12"
  exit
fi

case $env in

  'dev')
            
    account=573946347747
    profile=${account}_COBDeveloper
    ;;

  'qa')
    account=566383216324
    profile=${account}_COBSupport
    ;;

  *)
    echo 'environment not valid allowed dev qa'
    exit
    ;;
esac

region=us-east-1
containerName=$imageTag

echo 'Login aws ecr profile:' $profile
aws ecr --profile $profile get-login-password --region $region | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com

echo 'pull imageTag:' $imageTag
docker pull $account.dkr.ecr.$region.amazonaws.com/cobis/cwc-cloud:$imageTag

echo 'run container:' $imageTag
docker run --name $containerName -p 8080:8080 -d $account.dkr.ecr.$region.amazonaws.com/cobis/cwc-cloud:$imageTag 

targetPath=$(pwd)

echo 'Copy cobishome-web to:' $targetPath
docker cp $containerName:/home/cobisuser/cobishome-web $targetPath

echo 'Copy tomcat to:' $targetPath
docker cp $containerName:/usr/local/tomcat $targetPath

echo 'stopping docker:' $containerName
docker stop $containerName

echo 'removing docker:' $containerName
docker rm $containerName

sed -i '2d' $targetPath/tomcat/bin/catalina.sh

if [ -d $targetPath/cwc-assets ]; then
    echo 'Directory exists'
else
    echo 'Directory cwc-assets does not exist'
    exit
fi

infrastructurePath=$targetPath/cobishome-web/cwc/infrastructure/
cobisContainerPath=$targetPath/cobishome-web/cwc/services-as/cobis-container/
tomcatBinPath=$targetPath/tomcat/bin/

echo 'Copy cwc-log-config.xml to: ' $infrastructurePath
cp $targetPath/cwc-assets/cwc-log-config.xml $infrastructurePath

echo 'Copy cobis-container-config.xml settings to: ' $cobisContainerPath
cp $targetPath/cwc-assets/cobis-container-config.xml $cobisContainerPath 

echo 'Copy setenv.sh to: ' $tomcatBinPath
cp $targetPath/cwc-assets/cmv/setenv-$env.sh $tomcatBinPath/setenv.sh
