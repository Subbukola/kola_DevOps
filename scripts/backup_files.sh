#!/bin/bash

user_id="$(id -u)"
R='\033[0;31m'
N='\033[0;37m'
G='\033[0;32m'

if [ $user_id -ne 0 ]; then
    echo "$R You are not authorized to perform this task $N"

else

    echo "$G You are  authorized to perform this task $N"


fi