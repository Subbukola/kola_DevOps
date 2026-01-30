#!/bin/bash
directory="/var/log/scrip-logs"
file_path=$directory"/$0.log"
#status=$?
#echo "executing"

set -e # checks error . if found it will exit. return error code ERR to kernal in background
trap 'echo "error at $LINENO  and command --> $BASH_COMMAND" ' ERR

uid=$(id -u)


if ((uid !=0)); then
    echo "run as root user" | tee -a $file_path
    exit 1
fi
mkdir -p $directory


validate(){
    if (($1 != 0)); then
    echo "exit code $1, means $2 installation failure" | tee -a $file_path
    exit 1

else
    echo "status code $1, so $2 installationmeans successfull" | tee -a $file_path

fi

}

for package in $@
do
    dnf list installed $package &>>$file_path
    if (($? !=0)); then
        echo "$package is not installed" | tee -a $file_path   
        dnf install  $package -y &>>$file_path
        validate $? "Installing $package " | tee -a $file_path  

    else
        echo "$package is already installed"  | tee -a $file_path
    fi

done
#dnf install $package -y &>>$file_path
#validate $status "Installing nginx "
#status=$? 


#output--> sudo less /path.sh