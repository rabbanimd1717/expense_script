#!/bin/bash

set -e

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTING_NAME=$(echo $0 | cut -d "." -f2)
LOG_FILE=/tmp/$SCRIPTING_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE_FUN(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R FAILURE $N"
        exit 1
    else
        echo -e "$2 is $G SUCCESS $N"
    fi
}

USER_FUN(){
    if [ $USER_ID -eq 0 ]
    then
        echo -e "$Y INSTALLING PACKAGE $N"
    else
        echo "NEED TO SUDO USER FOR THIS PACKAGE INSTALLATION"
        exit 1
    fi
}