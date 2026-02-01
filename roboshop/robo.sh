#!/bin/bash

IMAGE_ID=ami-0220d79f3f480ecf5
SECURITY_GROUP_ID=sg-0905f25e83735d3d2




aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --instance-type t3.micro \
    --security-group-ids $SECURITY_GROUP_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyDemoInstance}]'
    
