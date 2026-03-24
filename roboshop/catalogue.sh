#!/bin/bash
directory="/var/log/mongo"
file_path=$directory"/$0.log"

RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
NORMAL="\e[0m"

 MONGODB_HOST=mongodb.kola.online

set -e # checks error . if found it will exit. return error code ERR to kernal in background
uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user" | tee -a $file_path
    exit 1
fi
mkdir -p $directory

validate(){
    if (($1 != 0)); then
    echo "exit code  $1, means $2 ${RED} failure" ${NORMAL} | tee -a $file_path
    exit 1

else
    echo "status code $1, so $2 ${GREEN} successfull" ${NORMAL} | tee -a $file_path

fi

}

dnf module disable nodejs -y
validate $? "disable nodeJS"

dnf module enable nodejs:20 -y
validate $? "enable nodeJS"

dnf install nodejs -y
validate $? "install nodeJS"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "adding user"

mkdir /app 
validate $? "creating directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
validate $? "copying"

cd /app 
validate $? "changing diretory"


rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATE $? "Uzip catalogue code"

npm install  &>>$LOGS_FILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Created systemctl service"

systemctl daemon-reload
systemctl enable catalogue  &>>$LOGS_FILE
systemctl start catalogue
VALIDATE $? "Starting and enabling catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOGS_FILE

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "Loading products"
else
    echo -e "Products already loaded ... $Y SKIPPING $N"
fi

systemctl restart catalogue
VALIDATE $? "Restarting catalogue"
