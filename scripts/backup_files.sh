#!/bin/bash

user_id="$(id -u)"

R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"

source_dir="/var/log/backup"
destination_dir="/home/root/backup_logs"

#step-1 --> to check user is root or not

if [ $user_id -ne 0 ]; then
    echo -e " ${R} You are not authorized to perform this task  ${N} "

else

    echo -e " ${G} You are  authorized to perform this task ${N} "


fi
#----------------------------------------------------------------------------
mkdir -p $source_dir
mkdir -p $destination_dir

