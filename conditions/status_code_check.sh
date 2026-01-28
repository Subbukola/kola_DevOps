#! /bin/bash

uid=$(id -u)

if ((uid !=0)); then
    echo "run as root user"
    exit 1
fi

dnf install  docker -y

if [$? -eq 0]; then
    echo "status code $?, means successfull"

else
    echo ' exit code $? means failure'

fi
