#!/bin/bash

USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTING_NAME=$(echo $0 | cut -d "-" -f1)
LOG_FILE=/tmp/$SCRIPTING_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "enter secret password of mysql"
read -s mysqlpassword

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

dnf module disable nodejs -y &>>$LOG_FILE

VALIDATE_FUN $? "DISABLING NODEJS"

dnf module enable nodejs:20 -y &>>$LOG_FILE

VALIDATE_FUN $? "ENABLING NODEJS"

dnf install nodejs -y &>> NODEJS &>>$LOG_FILE

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

dnf install mysql -y &>>$LOG_FILE
VALIDATE_FUN $? "INSTALL MYSQL IN BACKEND SCRIPT"

mysql -h 172.31.19.102 -uroot -p${mysqlpassword} < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE_FUN $? "attach the mysql with backend"

systemctl restart backend &>>$LOG_FILE
VALIDATE_FUN $? "Restarting the backend"


