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


mkdir -p $LOG_FOLDER
echo "script started excecuting at: $(date)" | tee -a "$LOG_FILE"

if [ $USER_ID -ne 0 ]; then
	echo -e "$R error $N: this script can be executed with root access"
	exit 1
else
	echo -e "$G success $N: Script is running with root access"
fi


VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "{R}error{N}: $2 failed" | tee -a "$LOG_FILE"
	else
		echo -e "{G}success{N}: $2 completed successfully" | tee -a "$LOG_FILE"
	fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "adding mongo repo" 

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installing mongodb" 

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb" 

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongodb" 

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "Updated listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarted mongodb" 

END_TIME=$(date +%s)
TIME_TAKEN=$(($END_TIME - $START_TIME))

echo "script ended excecuting at: $(date)" | tee -a $LOG_FILE


echo "total time taken to execute the script: $TIME_TAKEN seconds" | tee -a $LOG_FILE