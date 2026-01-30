#! /bin/bash
directory="/var/log/scrip-logs"
file_path=$directory"/$0.log"
#status=$?

uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user"
    exit 1
fi
mkdir -p $directory


validate(){
    if (($? !=0)); then
    echo "exit code $status, means failure"
    exit 1

else
    echo "status code $status, means successfull"

fi

}


dnf install  docker -y &>>$file_path
validate $? "Installing docker" 

dnf install  nginx -y &>>$file_path
validate $? "Installing nginx "
#status=$?

#output--> sudo less /path.sh