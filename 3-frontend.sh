#!/bin/bash

source ./common.sh

USER_FUN

dnf install nginx -y &>>$LOG_FILE

systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE

cd /usr/share/nginx/html &>>$LOG_FILE

unzip /tmp/frontend.zip &>>$LOG_FILE

cp /home/ec2-user/expense_script/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE

systemctl restart nginx &>>$LOG_FILE

systemctl status nginx &>>$LOG_FILE







