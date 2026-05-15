#!/bin/bash

R="\e[33m"
G="\e[32m"
Y="\e[31m"
N="\e[0m"

LOG_FOLDER="/var/log/mongo_logs"
SCRIPT_NAME=$( $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
	echo "error: this script can be executed with root access"
	exit 1
else
	echo "script started excecuting at $(%date)" | tee -a $LOG_FILE
fi

VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo "error: $2 failed to installed"
	else
		echo "success: $2 is installing..."
	fi
}

mkdir -p $LOG_FOLDER

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installing mongodb"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "Updated listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf"

systemctl restart mongod
VALIDATE $? "restarted mongodb"

netstat -lntp


