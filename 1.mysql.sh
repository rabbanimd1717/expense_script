#!/bin/bash

source ./common.sh

USER_FUN

echo "Please enter DB secure password"
read -s DB_PASSWORD

dnf install mysql-server -y >> $LOG_FILE

systemctl enable mysqld >> $LOG_FILE

systemctl start mysqld >> $LOG_FILE

# mysql_secure_installation --set-root-pass ExpenseApp@1 >> $LOG_FILE

mysql -h 172.31.19.102 -uroot -p${DB_PASSWORD} -e "SHOW DATABASES;"

if [ $? -eq 0 ]
then
    echo "already setup"
    exit 1
else
    mysql_secure_installation --set-root-pass ${DB_PASSWORD} &>> $LOG_FILE
fi

mkdir -p rabbani