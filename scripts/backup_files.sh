#!/bin/bash

user_id="$(id)"
R='\033[0;31m'
N='\033[0;37m'

if [$user_id -ne 0]; then
    echo "$R You are not authorized to perform this task $N"

fi