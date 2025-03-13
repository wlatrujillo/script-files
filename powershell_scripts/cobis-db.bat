
@echo off
setlocal
rem This script is to connect to the database of the environment.
rem This script takes one argument, the environment name.

set customer=%1
set env=%2

if not defined customer (
    echo customer and env are needed. Example: cobis-db.bat cobis dev1
    exit /b 1
)
if not defined env (
    echo customer and env are needed. Example: cobis-db.bat cobis dev1
    exit /b 1
)

if "%customer%"=="cobis" goto cobis
if "%customer%"=="cmv" goto cmv
if "%customer%"=="clf" goto clf

:cobis
if "%env%"=="dev1" (
    set profile=681989517074_COBDeveloper
    set region=us-east-1
    set hostdb=master.database.general.cob.cobiscloud.int
    set localPort=3315
)
if "%env%"=="dev2" (
    set profile=681989517074_COBDeveloper
    set region=us-east-1
    set hostdb=master.database.general.cob.cobiscloud.int
    set localPort=3316
)
if "%env%"=="dev3" (
    set profile=681989517074_COBDeveloper
    set region=us-east-1
    set hostdb=dev3-gp-cluster-rds-bck-24112023-dev3.cluster-ck9mgilqxnyv.us-east-1.rds.amazonaws.com
    set localPort=3317
)
if "%env%"=="dev4" (
    set profile=681989517074_COBDeveloper
    set region=us-east-1
    set hostdb=master.database.general.cob.cobiscloud.int
    set localPort=3318
)
if "%env%"=="dev5" (
    set profile=681989517074_COBDeveloper
    set region=us-east-1
    set hostdb=master.database.general.cob.cobiscloud.int
    set localPort=3319
)
if "%env%"=="qa1" (
    set profile=110595436954_COBSupport
    set region=us-east-1
    set hostdb=master.database.general.cob.cobiscloud.int
    set localPort=3415
)
if "%env%"=="stg1" (
    set profile=891377317704_COBSupport
    set region=us-east-1    
    set hostdb=master.database.general.cob.cobiscloud.int
    set localPort=3515
)
goto connect

:cmv
if "%env%"=="dev" (
    set profile=573946347747_COBDeveloper
    set region=us-east-1    
    set hostdb=master.database.general.cmv.cobiscloud.int
    set localPort=1055
)
if "%env%"=="qa" (
    set profile=566383216324_COBSupport
    set region=us-east-1    
    set hostdb=master.database.general.cmv.cobiscloud.int
    set localPort=1155
)
goto connect

:clf
goto connect


:connect
:: Use PowerShell to parse the JSON output from AWS CLI
echo Getting instanceId for: %customer% %env% 
for /f "tokens=*" %%i in ('aws ec2 --profile %profile% --region %region% describe-instances --filters "Name=tag:Name,Values=%env%-bastion-*" ^| powershell -Command "$input | ConvertFrom-Json | Select-Object -ExpandProperty Reservations | Select-Object -ExpandProperty Instances | Select-Object -ExpandProperty InstanceId | Select-Object -First 1"') do (
    set instanceId=%%i
)
echo aws ssm start-session --target %instanceId% --region %region% --profile %profile% --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=%localPort%,portNumber=3333,host=%hostdb%"
aws ssm start-session --target %instanceId% --region %region% --profile %profile% --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=%localPort%,portNumber=3333,host=%hostdb%"

endlocal

