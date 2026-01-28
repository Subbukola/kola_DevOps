#! /bin/bash


echo "ENter a number--> "
read num

if((num %2==0)); then
    echo "$num is even number"
else
    echo "$num is odd"

fi