
@echo off
rem This script is to connect to the database of the environment.
rem This script takes one argument, the environment name.

aws ssm start-session --target i-03c5ab56280cde7d5 --profile 681989517074_COBDeveloper --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "localPortNumber=3315,portNumber=3333,host=master.database.general.cob.cobiscloud.int"


