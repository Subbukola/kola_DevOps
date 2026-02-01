#!/bin/bash
directory="/var/log/mongo"
file_path=$directory"/$0.log"

RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
NORMAL="\e[0m"


set -e # checks error . if found it will exit. return error code ERR to kernal in background
uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user" | tee -a $file_path
    exit 1
fi
mkdir -p $directory

validate(){
    if (($1 != 0)); then
    echo "exit code  $1, means $2 $RED failure" $NORMAL | tee -a $file_path
    exit 1

else
    echo "status code $1, so $2 $GREEN successfull" $NORMAL | tee -a $file_path

fi

}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$file_path
validate $? "copying repo"

dnf install mongodb-org -y &>>$file_path
validate $? "mingoDB Installation"

systemctl enable mongod &>>$file_path
validate $? "mingoDB enabled"

systemctl start mongod &>>$file_path
validate $? "mingoDB started"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$file_path
validate $? "updating ip address"

systemctl restart mongod &>>$file_path
validate $? "restarting mongoDB"



