#!/bin/bash

user_id="$(id -u)"
R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"


if [ $user_id -ne 0 ]; then
    echo -e " ${R} You are not authorized to perform this task  ${N} "

else

    echo -e " ${G} You are  authorized to perform this task ${N} "


fi