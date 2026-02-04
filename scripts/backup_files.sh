#!/bin/bash

user_id="$(id -u)"

R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"

source_dir="/var/log/backup"
destination_dir="/home/root/backup_logs"

days=${1:-14}

#step-1 --> to check user is root or not

if [ $user_id -ne 0 ]; then
    echo -e " ${R} You are not authorized to perform this task  ${N} "

else

    echo -e " ${G} You are  authorized to perform this task ${N} "


fi
#----------------------------------------------------------------------------
mkdir -p "$source_dir"
mkdir -p "$destination_dir"
#------------------------------------------------------------------------------

FILES=$(find "$source_dir" -name "*.log" -type f -mtime +$days)

if [ -z "$FILES" ]; then
    echo -e " ${R} no files to take backup${N} "
    exit 1
else
    echo -e  " ${G} --- FILES FOUND FOR BACKUP--- ${N} "
    timestamp=$(date +%F_%H-%M-%S)
    Backup_zip_files="$destination_dir/app_log_$timestamp.tar.gz"
    echo -e " ${Y} archieving files ${N}"
    tar -zcf $Backup_zip_files $(find "$source_dir" -name "*.log" -type f -mtime +$days)
fi

#-----------------------------------------------------

#check stats code and see output
if [ $? -ne 0 ]; then
    echo -e " ${R} looks something is wrong ${N}"

else
    echo -e " ${G} backup done ${N}"
fi

#----------------------------------------------------------

if [ -f $Backup_zip_files ]; then
    echo -e " ${G} Archieve done ${N}"

fi
echo "$destination_dir"
#-----------------------------------------------------------------------------

