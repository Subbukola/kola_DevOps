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

    echo "Instance ID = '$Instance_Id'"    

done
    
#aws ec2 describe-instances --instance-ids <your_instance_id> \
 #--query 'Reservations[*].Instances[*].PublicIpAddress' \
#  --output text
