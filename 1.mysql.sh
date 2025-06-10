#!/bin/bash

source ./common.sh

USER_FUN


echo "Please enter DB secure password"
read -s DB_PASSWORD




dnf install mysql-server -y >> $LOG_FILE

VALIDATE_FUN $? "INSTALLING MYSQL"

systemctl enable mysqld >> $LOG_FILE

VALIDATE_FUN $? "ENABLED MYSQL"

systemctl start mysqld >> $LOG_FILE

VALIDATE_FUN $? "START MYSQL"

# mysql_secure_installation --set-root-pass ExpenseApp@1 >> $LOG_FILE

mysql -h 172.31.19.102 -uroot -p${DB_PASSWORD} -e "SHOW DATABASES;"

if [ $? -eq 0 ]
then
    echo "already setup"
    exit 1
else
    mysql_secure_installation --set-root-pass ${DB_PASSWORD} &>> $LOG_FILE
    VALIDATE_FUN $? "SETUP ROOT PASSWORD"
fi

mkdir -p rabbani