
param(
    [string]$env,
    [string]$imageTag
)

if (-not $env -or -not $imageTag) {
    Write-Host "environment and imageTag is required example: $MyInvocation.MyCommand dev1 producto-dev1-cwc-2.60.5"
    exit
}

switch ($env) {
    'dev1' {
        $account = 681989517074
        $profile = "${account}_COBDeveloper"
    }
    'qa1' {
        $account = 110595436954
        $profile = "${account}_COBTester"
    }
    default {
        Write-Host 'environment not valid allowed dev1 qa1'
        exit
    }
}

$region = 'us-east-1'
$containerName = $imageTag

Write-Host "Login aws ecr profile: $profile"
"aws ecr --profile ${profile} get-login-password --region ${region} | docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com"

Write-Host "pull imageTag: $imageTag"
"docker pull ${account}.dkr.ecr.${region}.amazonaws.com/cobis/cwc-cloud:${imageTag}"

Write-Host "run container: $imageTag"
"docker run --name ${containerName} -p 8080:8080 -d ${account}.dkr.ecr.${region}.amazonaws.com/cobis/cwc-cloud:${imageTag}" 

$targetPath = Get-Location

Write-Host "Copy cobishome-web to: ${targetPath}"
"docker cp ${containerName}:/home/cobisuser/cobishome-web ${targetPath}"

Write-Host "Copy tomcat to: ${targetPath}"
"docker cp ${containerName}:/usr/local/tomcat ${targetPath}"

Write-Host "stopping docker: ${containerName}"
"docker stop ${containerName}"

Write-Host "removing docker: $containerName"
#"docker rm ${containerName}"

if (Test-Path "${targetPath}/cwc-assets") {
    Write-Host 'Directory exists'
} else {
    Write-Host 'Directory cwc-assets does not exist'
    exit
}

$infrastructurePath = "${targetPath}\\cobishome-web\\cwc\\infrastructure"
$cobisContainerPath = "${targetPath}\\cobishome-web\\cwc\\services-as\\cobis-container"
$tomcatBinPath = "${targetPath}\\tomcat\\bin"

Write-Host "Copy cwc-log-config.xml to: $infrastructurePath"
Copy-Item "${targetPath}\\cwc-assets\\cwc-log-config.xml" $infrastructurePath

Write-Host "Copy cobis-container-config.xml settings to: $cobisContainerPath"
Copy-Item "${targetPath}\\cwc-assets\\cobis-container-config.xml" $cobisContainerPath 

Write-Host "Copy setenv.bat to: $tomcatBinPath"
Copy-Item "${targetPath}\\cwc-assets\\cobis\\setenv-${env}.bat" "$tomcatBinPath\\setenv.bat"