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
    if (($? !=0)); then
    echo "exit code $?, means failure" | tee -a $file_path
    exit 1

else
    echo "status code $?, means successfull" | tee -a $file_path

fi

}

for package in $@
do
    dnf list installed $package &>>$file_path
    if (($? !=0)); then
        echo "$package is not installed"   
        dnf install  $package -y &>>$file_path
        validate $? "Installing $package "   

    else
        echo "$package is already installed"  
    fi

done
dnf install  nginx -y &>>$file_path
validate $? "Installing nginx "
#status=$?

#output--> sudo less /path.sh