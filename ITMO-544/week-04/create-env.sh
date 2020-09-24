#!/bin/bash

echo Installing jq package to parse instanceID
echo \ =============================================================== \

sudo apt-get install jq

echo jq Installed successfully
echo \ =============================================================== \

echo Creating your EC2 Instance
echo \ =============================================================== \

read instanceID1 instanceID2 instanceID3 < <(echo $(aws ec2 run-instances --image-id ami-06b263d6ceff0b3dd --instance-type t2.micro --security-group-ids sg-9abcd0a6 --key-name windows-laptop-bionic-v2 --user-data file://install_apache.txt --count 3 --output text --query 'Instances[*].InstanceId'))
aws ec2 wait instance-running --instance-ids $instanceID1 $instanceID2 $instanceID3 

read dns1 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID1} --output text --query 'Reservations[0].Instances[0].PublicDnsName'))
read dns2 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID2} --output text --query 'Reservations[0].Instances[0].PublicDnsName'))
read dns3 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID3} --output text --query 'Reservations[0].Instances[0].PublicDnsName'))

echo Your Instance ID is ${instanceID1}
echo Your Instance ID is ${instanceID2}
echo Your Instance ID is ${instanceID3}
echo \ =============================================================== \

echo Creating....Initializing...Starting you EC2 Instance
echo \ =============================================================== \

read subnet1 subnet2 < <(echo $(aws ec2 describe-subnets --output text --query 'Subnets[*].SubnetId'))

read vpcId < <(echo $(aws elbv2 create-load-balancer --name my-load-balancer --subnets $subnet1 $subnet2 --output text  --query 'LoadBalancers[0].VpcId'))

aws elbv2 create-target-group --name my-targets --protocol HTTP --port 80 --target-type instance --vpc-id $vpcId

aws elbv2 wait load-balancer-available

read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --output text --query TargetGroups[0].[TargetGroupArn]))
read loadBalancerArn < <(echo $(aws elbv2 describe-load-balancers --output text --query LoadBalancers[0].LoadBalancerArn))

ehco load $loadBalancerArn

aws elbv2 register-targets --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3

aws elbv2 create-listener --load-balancer-arn $loadBalancerArn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$targetGroupArn

aws elbv2 modify-target-group --target-group-arn $targetGroupArn  --health-check-protocol HTTP --health-check-port 80

aws elbv2 describe-target-group-attributes --target-group-arn $targetGroupArn