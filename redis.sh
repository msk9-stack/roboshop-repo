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
	echo -e "$R error $N: this script can be executed with root access"
	exit 1
else
	echo -e "$G success $N: Script is running with root access"
fi


VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "error: $2 installation..$R failed $N"
	else
		echo -e "$2 installation $G success $N"
	fi
}

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disabling redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enable redis:7"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "installing redis..."

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "allowing remote access"

sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "updating protected mode yes to no"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "enble redis"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "start redis"

sleep 5

echo "script started excecuting at: $END_TIME" | tee -a $LOG_FILE
echo "Total duration of the script: $TIME_TAKEN sec"
