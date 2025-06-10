#!/bin/bash

source ./common.sh

USER_FUN

echo "enter secret password of mysql"
read -s mysqlpassword



dnf module disable nodejs -y &>>$LOG_FILE

VALIDATE_FUN $? "DISABLING NODEJS"

dnf module enable nodejs:20 -y &>>$LOG_FILE

VALIDATE_FUN $? "ENABLING NODEJS"

dnf install nodejs -y &>>$LOG_FILE

VALIDATE_FUN $? "INSTALLING NODEJS"

id expense &>>$LOG_FILE

if [ $? -ne 0 ]
then
    useradd expense &>>$LOG_FILE
    VALIDATE_FUN $? "USER CREATING"
else
    echo -e "$G USER ALREADY EXISTING $Y SKIPPING $N"
fi

mkdir -p /app &>>$LOG_FILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $LOG_FILE

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE_FUN $? "UNZIP THE FILE"

npm install &>>$LOG_FILE
VALIDATE_FUN $? "NPM DEPENDENCIES INSTALLING"

cp /home/ec2-user/expense_script/backend.service /etc/systemd/system/backend.service
VALIDATE_FUN $? "COPIED backend.service"

systemctl daemon-reload &>>$LOG_FILE

systemctl start backend &>>$LOG_FILE

systemctl enable backend &>>$LOG_FILE
VALIDATE_FUN $? "daemon reload, start and enable successfully"

dnf install mysql -y &>> $LOG_FILE
VALIDATE_FUN $? "INSTALL MYSQL IN BACKEND SCRIPT"

mysql -h 172.31.19.102 -uroot -p${mysqlpassword} < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE_FUN $? "attach the mysql with backend"

systemctl restart backend &>>$LOG_FILE
VALIDATE_FUN $? "Restarting the backend"

dnf install git -y &>>$LOG_FILE
VALIDATE_FUN $? "INSTALLIN GIT"


