#! /bin/bash
directory="/var/log/scrip-logs"
file_path=$directory"/$0.sh"
#status=$?

uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user" | tee -a $file_path
    exit 1
fi
mkdir -p $directory


validate(){
    if ((status !=0)); then
    echo "exit code $?, means failure" | tee -a $file_path
    exit 1

else
    echo "status code $?, means successfull" | tee -a $file_path

fi

}

for package in $@
do
    dnf install  $? -y &>>$file_path
    validate $? "Installing $package "   

done


dnf install  nginx -y &>>$file_path
validate $? "Installing nginx "
#status=$?

#output--> sudo less /path.sh