#!/bin/sh

account=681989517074
profile=${account}_COBDeveloper
env=dev1

bucket=$env-ddaccounts-t1-batch-executablefiledirectory-$account

path=~/git-cta/cobis-ddaccounts-serverless-service/cobis-ddaccounts-file-upload-batch/target
file=cobis-ddaccounts-file-upload-batch.jar

echo 'profile: ' $profile
echo 'file: ' $file 
echo 'bucket: ' $bucket

#echo 'Uploading to: ' $bucket
#aws s3 cp --profile $profile $path/$file s3://$bucket 

