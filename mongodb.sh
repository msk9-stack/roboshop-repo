#!/bin/bash

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/mongo_logs"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
END_TIME=$(date +%s)
TIME_TAKEN=$(($END_TIME - $START_TIME))

mkdir -p $LOG_FOLDER
echo "script started excecuting at: $START_TIME" | tee -a $LOG_FILE

if [ $USER_ID -ne 0 ]; then
	echo "error: this script can be executed with root access"
	exit 1
else
	echo "success: Script is running with root access"
fi


VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "error: $2 $R failed $N"
	else
		echo -e "success: $2 $G success $N"
	fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "adding mongo repo" | tee - a $LOG_FILE

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installing mongodb" | tee - a $LOG_FILE

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb" | tee - a $LOG_FILE

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongodb" | tee - a $LOG_FILE

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "Updated listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf" | tee - a $LOG_FILE

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarted mongodb" | tee - a $LOG_FILE

netstat -lntp | tee - a $LOG_FILE

echo "script ended excecuting at: $END_TIME" | tee -a $LOG_FILE
echo "total time taken to execute the script: $TIME_TAKEN seconds" | tee -a $LOG_FILE
