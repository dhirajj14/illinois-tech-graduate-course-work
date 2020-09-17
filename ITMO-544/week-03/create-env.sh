#!/bin/bash

echo Installing jq package to parse instanceID
echo \ =============================================================== \

sudo apt-get install jq

echo jq Installed successfully
echo \ =============================================================== \

echo Creating your EC2 Instance
echo \ =============================================================== \

read instanceID < <(echo $(aws ec2 run-instances --image-id ami-06b263d6ceff0b3dd --instance-type t2.micro --security-group-ids sg-9abcd0a6 --key-name windows-laptop-bionic-v2 --user-data file://install_apache.txt | jq --raw-output '.Instances[0].InstanceId'))

dns=$(aws ec2 describe-instances --instance-ids ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].PublicDnsName')

echo Your Instance ID is ${instanceID}
echo \ =============================================================== \

echo Creating....Initializing...Starting you EC2 Instance
echo \ =============================================================== \

while [ "$dns" == "" ]
do
    dns=$(aws ec2 describe-instances --instance-ids ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].PublicDnsName')
done


status=$(aws ec2 describe-instances --instance-ids  ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].State.Name')


while [ "$status" != "running" ]
do
    status=$(aws ec2 describe-instances --instance-ids  ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].State.Name')
    echo Initializing.....
done

echo \ =============================================================== \
echo Your Apache server is up and ready to use

echo \ =============================================================== \
echo This is dns ${dns}

echo \ =============================================================== \
echo Login you into the Instance

echo \ =============================================================== \
ssh -i ./windows-laptop-bionic-v2.priv -y ubuntu@${dns}
