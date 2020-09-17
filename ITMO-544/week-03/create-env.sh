#!/bin/bash

echo Installing jq package to parse instanceID

sudo apt-get install jq

echo jq Installe successfully

echo Creating you EC2 Instance

read instanceID < <(echo $(aws ec2 run-instances --image-id ami-06b263d6ceff0b3dd --instance-type t2.micro --security-group-ids sg-9abcd0a6 --key-name windows-laptop-bionic-v2 --user-data file://install_apache.txt | jq --raw-output '.Instances[0].InstanceId'))
reads=$(aws ec2 describe-instances --instance-ids ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].PublicDnsName')
echo Your Instance ID is ${instanceID}
echo Creating....Initializing...Starting you EC2 Instance
while [ "$reads" == "" ]
do
    reads=$(aws ec2 describe-instances --instance-ids ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].PublicDnsName')
done

status=$(aws ec2 describe-instances --instance-ids  ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].State.Name')

while [ "$status" != "running" ]
do
    status=$(aws ec2 describe-instances --instance-ids  ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].State.Name')
    echo Initializing.....
done

echo Your Apache server is up and ready to user

echo This is dns ${reads}


