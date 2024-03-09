#!/bin/sh

# Kill all processes with the name $1 (the first command line argument)

name=$1

if [ -z $name ]; then
  echo "Usage: $0 processname"
  exit 1
fi

kill -9 $(ps -edaf | grep $name | grep -v grep | awk '{ print $2 }')
