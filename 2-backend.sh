#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTING_NAME=$(echo $0 | cut -d "-" -f1)
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

if [ $USER_ID -ne 0 ]
then
    echo "NEED TO DO WITH SUPER USER DOWNLOAD THIS PACKAGE"
    exit 1
else
    echo "THIS IS SUPER USER INSTALLING PACKAGE WITHOUT INTERUPPTIONS"
fi

dnf module disable nodejs -y &>> LOG_FILE

VALIDATE_FUN $? "DISABLING NODEJS"

dnf module enable nodejs:20 -y &>> LOG_FILE

VALIDATE_FUN $? "ENABLING NODEJS"

dnf install nodejs -y &>> NODEJS

VALIDATE_FUN $? "INSTALLING NODEJS"

id expense



