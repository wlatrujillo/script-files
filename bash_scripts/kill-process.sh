#!/bin/sh

# Kill all processes with the name $1 (the first command line argument)

DisplayHelp()
{
   # Display Help
   echo
   echo "Help:"
   echo
   echo "Kill all processes with the name \$1 (the first command line argument)"
   echo
   echo "Syntax: scriptTemplate [-h] <process_name>"
   echo
   echo "Options:"
   echo "  -h    Print this Help."
   echo
   echo "Arguments:"
   echo
   echo "process_name: The name of the process."
   echo
   echo "Usage:"
   echo
   echo "sh $0 vscode"
   echo "sh $0 intellij-idea-ultimate"
   echo "sh $0 chrome"
   echo "sh $0 dbeaver-ce"
}


# Get the options
while getopts ":h:" option; do
   case $option in
      h) # Display Help
         DisplayHelp
         exit;;
      \?) # Incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $((OPTIND - 1))

# Check if enough arguments are provided
if [ "$#" -ne 1 ]; then
    DisplayHelp
    exit 1
fi

name=$1

kill -9 $(ps -edaf | grep $name | grep -v grep | awk '{ print $2 }')
