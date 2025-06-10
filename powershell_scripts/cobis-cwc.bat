
@echo off
setlocal
rem This script is to download cwc image locally.
rem This script takes 3 arguments, customer environment containerTagId.

set customer=%1
set env=%2
set containerTag=%3

if not defined customer (
    echo customer env containerTag are needed. Example: cobis-cwc.bat cobis dev1 deveop-1.2.45-SNAPSHOT
    exit /b 1
)
if not defined env (
    echo customer env containerTag are needed. Example: cobis-cwc.bat cobis dev1 develop-1.2.45-SNAPSHOT
    exit /b 1
)
if not defined containerTag (
    echo customer env containerTag are needed. Example: cobis-cwc.bat cobis dev1 develop-1.2.45-SNAPSHOT
    exit /b 1
)

if "%customer%"=="cobis" goto cobis

:cobis
if "%env%"=="dev1" (
    set account=681989517074
    set profile=681989517074_COBDeveloper
    set region=us-east-1
)
if "%env%"=="qa1" (
    set account=110595436954
    set profile=110595436954_COBSupport
    set region=us-east-1
)
goto download

:download
echo Login aws ecr profile: %profile%
aws ecr --profile %profile% get-login-password --region %region% | docker login --username AWS --password-stdin %account%.dkr.ecr.%region%.amazonaws.com

echo pull containerTag: %containerTag%
docker pull %account%.dkr.ecr.%region%.amazonaws.com/%env%/cobis/infra-cwc:%containerTag%

echo run container: %containerTag%
docker run --name %containerTag% -d %account%.dkr.ecr.%region%.amazonaws.com/%env%/cobis/infra-cwc:%containerTag%

set targetPath=%CD%

echo Copy cobishome-web to: %targetPath%
docker cp %containerTag%:/home/cobisuser/cobishome-web %targetPath%

echo Copy tomcat to: %targetPath%
docker cp %containerTag%:/usr/local/tomcat %targetPath%

echo stopping docker: %containerTag%
docker stop %containerTag%

echo removing docker: %containerTag%
docker rm %containerTag%

set infrastructurePath=%targetPath%\cobishome-web\cwc\infrastructure
set cobisContainerPath=%targetPath%\cobishome-web\cwc\services-as\cobis-container
set tomcatBinPath=%targetPath%\tomcat\bin

echo Copy cwc-log-config.xml to: %infrastructurePath%
copy /Y %targetPath%\cwc-assets\cwc-log-config.xml %infrastructurePath%

echo Copy cobis-container-config.xml settings to: %cobisContainerPath%
copy /Y %targetPath%\cwc-assets\cobis-container-config.xml %cobisContainerPath%

echo Copy setenv.bat to: %tomcatBinPath%
copy /Y %targetPath%\cwc-assets\cobis\setenv-%env%.bat %tomcatBinPath%\setenv.bat

endLocal