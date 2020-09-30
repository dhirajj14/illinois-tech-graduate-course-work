#!/bin/bash

# Variables to run the Script
# $1    ImageID
# $2    Count
# $3)	Subnet 1 (availability zone a for your region) for load balancer
# $4)	Subnet 2 (availability zone b for your region) for load balancer
# $5)	subnet-id for EC2 launch instance (availability zone a) (may or may not be used depending on your design)
# $6)	Security Group ID
# $7)	Load balancer name
# $8)	Target Group name
# $9)	Key-pair name
# ${10})	auto-scaling-group-name
# ${11})	launch-configuration-name
# ${12})	vpc-id You can have the user prompt this or you can retrieve it

#Create launch Configuration

#create-launch-configuration --launch-configuration-name <launch-configuration-name> --image-id <image-ID> --instance-type t2.micro --security-groups <Security-Group-Name --key-name <key-pair> --user-data file://install-env.sh
create-launch-configuration --launch-configuration-name ${11} --image-id $1 --instance-type t2.micro --security-groups $6 --key-name $9 --user-data file://install_apache.sh


   