#!/bin/bash

IMAGE_ID=ami-0220d79f3f480ecf5
SECURITY_GROUP_ID=sg-0905f25e83735d3d2


for INSTANCE in $@
do

    INSTANCE_ID= $(aws ec2 run-instances \
        --image-id $IMAGE_ID \
        --instance-type t3.micro \
        --security-group-ids $SECURITY_GROUP_ID \
        --query 'Instances[0].InstanceId' \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCE'}]' \
        --output text
        )


    if (( $INSTANCE == frontend)); then
        PUBLIC_IP= $(
        aws ec2 describe-instances --instance-ids $INSTANCE_ID \
        --query '.Instances[0].PublicIpAddress' \
        --output text
        )
      echo "public_IP= $PUBLIC_IP'"  

    else 
        PRIVATE_IP= $(
        aws ec2 describe-instances --instance-ids $INSTANCE_ID \
        --query '.Instances[0].PrivateIpAddress' \
        --output text
        )
      echo "private_IP= $PRIVATE_IP_IP'" 

    fi

done
    
#aws ec2 describe-instances --instance-ids <your_instance_id> \
 #--query 'Reservations[*].Instances[*].PublicIpAddress' \
#  --output text
