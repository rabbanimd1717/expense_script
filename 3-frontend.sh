#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "-" -f2)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

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

dnf install nginx -y &>>$LOG_FILE
VALIDATE_FUN $? "NGINX INSTALLATION PACKAGE"

systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE
VALIDATE_FUN $? "NGINX ENABLING AND START"


