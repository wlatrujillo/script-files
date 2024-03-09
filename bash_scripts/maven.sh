#!/bin/sh
if [ -z ${M2_HOME+x} ];
then
export M2_HOME=~/apache-maven-3.9.6
export PATH=$PATH:$M2_HOME/bin
fi
