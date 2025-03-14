#!/bin/sh
#
customer=$1
env=$2
imageTag=$3

if [ ! "$customer" ] || [ ! "$env" ] || [ ! "$imageTag" ]
then
  echo "customer and environment and imageTag is required example: $0 cobis dev1 producto-dev1-cwc-2.60.4"
  exit
fi

case $customer in 
    
      'cobis')
        case $env in

          'dev1')
            account=681989517074
            profile=COBDeveloper-${account}
            ;;

          'qa1')
            account=110595436954
            profile=COBSupport-${account}
            ;;

          *)
            echo 'environment not valid allowed dev1 qa1'
            exit
            ;;
        esac
     ;;
    
      'cmv')
        case $env in

          'dev')
            account=573946347747
            profile=COBDeveloper-${account}
            ;;

          'qa')
            account=566383216324
            profile=COBSupport-${account}
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

region=us-east-1
#containerImage=$account.dkr.ecr.$region.amazonaws.com/cobis/cwc-cloud:$imageTag
containerImage=$account.dkr.ecr.$region.amazonaws.com/$env/cobis/infra-cwc:$imageTag

echo "aws ecr --profile $profile get-login-password --region $region | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com"
aws ecr --profile $profile get-login-password --region $region | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com

echo 'pull imageTag:' $containerImage
docker pull $containerImage 

echo 'run container:' $imageTag
docker run --name $imageTag -p 8080:8080 -d $containerImage

targetPath=$(pwd)

echo 'Copy cobishome-web to:' $targetPath
docker cp $imageTag:/home/cobisuser/cobishome-web $targetPath

echo 'Copy tomcat to:' $targetPath
docker cp $imageTag:/usr/local/tomcat $targetPath

echo 'stopping docker container:' $imageTag
docker stop $imageTag

echo 'removing docker:' $imageTag
docker rm $imageTag

echo 'removing docker image:' $containerImage 
docker rmi $containerImage

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
cp $targetPath/cwc-assets/cobis/setenv-$env.sh $tomcatBinPath/setenv.sh
