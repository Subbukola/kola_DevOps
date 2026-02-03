#! /bin/bash

#1 means success output ls -l 1
#0 fail output or error ls -l 0
# for anything  ls -l &

uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user"
    exit 1
fi


#status=$?
echo "enter servicename:->"
read servicename


validate(){
    if (($? !=0)); then
    echo "exit code $1, means $2 is failed"
    exit 1

else
    echo "status code $1, means $2 successfull"

fi

}


dnf install  $servicename -y
validate $? "Installing docker" 

#dnf install  nginx -y
#validate $status "Installing nginx "
#status=$?
