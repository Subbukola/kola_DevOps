#!/bin/bash

IMAGE_ID=ami-0220d79f3f480ecf5
SECURITY_GROUP_ID=sg-0905f25e83735d3d2
HOSTED_ZONE_ID=Z10262718FD0B5C9MRAM
DOMAIN_NAME=kola88.online


for INSTANCE in $@
do

    INSTANCE_ID=$(
        aws ec2 run-instances \
        --image-id $IMAGE_ID \
        --instance-type t3.micro \
        --security-group-ids $SECURITY_GROUP_ID \
        --query 'Instances[].InstanceId' \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCE'}]' \
        --output text
        )
        echo "Instance ID: $INSTANCE_ID"
        echo "Instance name : $INSTANCE"

    if (( $INSTANCE == "frontend")); then
        IP=$(
        aws ec2 describe-instances --instance-ids $INSTANCE_ID \
        --query 'Reservations[].Instances[].PublicIpAddress' \
        --output text
        )
      echo "public_IP= $IP'"  
      HOSTED_RECORD="$DOMAIN_NAME"

    else 
        IP=$(
        aws ec2 describe-instances --instance-ids $INSTANCE_ID \
        --query 'Reservations[]Instances[].PrivateIpAddress' \
        --output text
        )
      echo "private_IP= $IP'" 
      HOSTED_RECORD="$INSTANCE.$DOMAIN_NAME"

    fi
    aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZONE_ID \
  --change-batch '{
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$HOSTED_RECORD'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            { "Value": "'$IP'" }
          ]
        }
      }
    ]
  }'


done
    
