#! /bin/bash

uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user"
    exit 1
fi

dnf install  docker -y
status=$?

if ((status !=0)); then
    echo "exit code $status, means failure"
    exit 1

else
    echo "status code $status, means successfull"

fi
