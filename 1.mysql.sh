#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTING_NAME=$(echo $0 | cut -d "." -f2)
LOG_FILE=/tmp/$SCRIPTING_NAME-$TIMESTAMP.log

VALIDATE_FUN(){
    if [ $1 -eq 0 ]
    then
        echo "$2 is SUCCESS"
    else
        echo "$2 is FAILURE"
}

if [ $USER_ID -eq 0 ]
then
    echo "INSTALLING PACKAGE"
else
    echo "NEED TO SUDO USER FOR THIS PACKAGE INSTALLATION"


dnf install mysql-server -y >> $LOG_FILE

VALIDATE_FUN $? "INSTALLING MYSQL"

systemctl enable mysqld >> $LOG_FILE

VALIDATE_FUN $? "ENABLED MYSQL"

systemctl start mysqld >> $LOG_FILE

VALIDATE_FUN $? "START MYSQL"

mysql_secure_installation --set-root-pass ExpenseApp@1

VALIDATE_FUN $? "SETUP ROOT PASSWORD"