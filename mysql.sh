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
TIME_TAKEN=$((END_TIME - START_TIME))

mkdir -p $LOG_FOLDER
echo "script started excecuting at: $(date)" | tee -a $LOG_FILE

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

dnf install mysql-server -y &>>LOG_FILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>LOG_FILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>LOG_FILE
VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>LOG_FILE
VALIDATE $? "setting up the root password for mysql"

echo "script started excecuting at: $(date)" | tee -a $LOG_FILE
echo "total time taken for script to execute: $TIME_TAKEN sec" | tee -a $LOG_FILE
