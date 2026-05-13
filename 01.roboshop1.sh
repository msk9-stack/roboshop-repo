#!/bin/bash

INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --instance-type t3.micro --security-group-ids sg-0cf96f7c7fcb5a583 --query 'Instances[0].InstanceId')
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].[InstanceID,PublicIpAddress]')
PRIVATE_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].[InstanceID,PrivateIpAddress]')

for server in "$@"
do
	if [ $frontend -ne 0 ]; then
		echo "Private Ip is: $PRIVATE_IP"
	else
		echo "Public IP is: $PUBLIC_IP"
	fi
done