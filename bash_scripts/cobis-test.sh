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
targetDir=$(pwd)
echo "targetDir: $targetDir" 



