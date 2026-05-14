#!/bin/bash

AMI_ID=ami-0220d79f3f480ecf5
SG_ID=sg-0cf96f7c7fcb5a583
HOSTED_ZONE=Z07452733M0KKP6J4JY7P
DOMAIN_NAME=msk-dps.xyz

for instance in "$@"
do
	INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]' --query 'Instances[0].InstanceId' --output text)
	if [ $instance != "frontend" ]; then
		IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]")
		echo "$instance: $IP"
    else
		IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].[InstanceId,PublicIpAddress]")
		echo "$instance: $IP"
	fi
done