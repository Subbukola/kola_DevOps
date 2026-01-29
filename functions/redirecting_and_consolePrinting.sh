#! /bin/bash
directory="/var/log/scrip-logs"
file_path=$directory"/$0.sh"
status=$?

uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user" | tee -a $file_path
    exit 1
fi
mkdir -p $directory


validate(){
    if ((status !=0)); then
    echo "exit code $status, means failure" | tee -a $file_path
    exit 1

else
    echo "status code $status, means successfull" | tee -a $file_path

fi

}


dnf install  docker -y &>>$file_path
validate $status "Installing docker" 

dnf install  nginx -y &>>$file_path
validate $status "Installing nginx "
#status=$?

#output--> sudo less /path.sh