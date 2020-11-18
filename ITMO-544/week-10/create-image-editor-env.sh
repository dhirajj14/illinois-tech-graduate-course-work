#!/bin/bash

echo Creating your EC2 Instance
echo \ =============================================================== \

read instanceID1 < <(echo $(aws ec2 run-instances --image-id $1 --instance-type t2.micro --security-group-ids $3 --key-name $4 --user-data file://install-env-image-editor-env.txt --iam-instance-profile Arn=${5} --output text --query 'Instances[*].InstanceId'))

aws ec2 wait instance-running --instance-ids $instanceID1 