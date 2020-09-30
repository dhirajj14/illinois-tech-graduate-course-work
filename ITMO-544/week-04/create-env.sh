#!/bin/bash

echo Creating your EC2 Instance
echo \ =============================================================== \

read instanceID1 instanceID2 instanceID3 < <(echo $(aws ec2 run-instances --image-id ami-06b263d6ceff0b3dd --instance-type t2.micro --security-group-ids sg-9abcd0a6 --key-name windows-laptop-bionic-v2 --user-data file://install_apache.txt --count 3 --output text --query 'Instances[*].InstanceId'))
aws ec2 wait instance-running --instance-ids $instanceID1 $instanceID2 $instanceID3 

echo Enter the Tag for your instace resourse and note it down...It will be asked while deleting resourses
read tag

aws ec2 create-tags --resources $instanceID1 $instanceID2 $instanceID3  --tags Key=Name,Value=$tag

echo \ =============================================================== \

read dns1 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID1} --output text --query 'Reservations[0].Instances[0].PublicDnsName'))
read dns2 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID2} --output text --query 'Reservations[0].Instances[1].PublicDnsName'))
read dns3 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID3} --output text --query 'Reservations[0].Instances[2].PublicDnsName'))

echo Your Instance ID is ${instanceID1}
echo Your Instance ID is ${instanceID2}
echo Your Instance ID is ${instanceID3}
echo \ =============================================================== \

echo Creating....Initializing...Starting you EC2 Instance
echo \ =============================================================== \

echo Getting Subnets

read subnet1 subnet2 < <(echo $(aws ec2 describe-subnets --output text --query 'Subnets[*].SubnetId'))

echo Your subnets are $subnet1 and $subnet2

echo \ =============================================================== \

echo Getting VpcId

read vpcId < <(echo $(aws elbv2 create-load-balancer --name my-load-balancer --subnets $subnet1 $subnet2 --output text  --query 'LoadBalancers[0].VpcId'))

echo your VpcId is $vpcId

echo \ =============================================================== \

echo Getting Creating target group my-targets
echo \ =============================================================== \

aws elbv2 create-target-group --name my-targets --protocol HTTP --port 80 --target-type instance --vpc-id $vpcId

echo Waiting /for load-balancer to be active
echo \ =============================================================== \

aws elbv2 wait load-balancer-available

echo Getting Target Groups ARN and Load Balancer ARN
echo \ =============================================================== \

read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --output text --query TargetGroups[0].[TargetGroupArn]))
read loadBalancerArn < <(echo $(aws elbv2 describe-load-balancers --output text --query LoadBalancers[0].LoadBalancerArn))


echo Registering Target
echo \ =============================================================== \

$(aws elbv2 register-targets --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3)

echo Creating Listener
echo \ =============================================================== \
$(aws elbv2 create-listener --load-balancer-arn $loadBalancerArn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$targetGroupArn)

echo Modifying Target Group
echo \ =============================================================== \
echo $(aws elbv2 modify-target-group --target-group-arn $targetGroupArn  --health-check-protocol HTTP --health-check-port 80)

aws elbv2 describe-target-group-attributes --target-group-arn $targetGroupArn
echo Finished!!
echo \ =============================================================== \