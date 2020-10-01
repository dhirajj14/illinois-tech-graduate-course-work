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
aws autoscaling create-launch-configuration --launch-configuration-name ${11} --image-id $1 --instance-type t2.micro --security-groups $6 --key-name $9 --user-data file://install_apache.sh

read vpcId < <(echo $(aws elbv2 create-load-balancer --name $7 --subnets $3 $4 --output text  --query 'LoadBalancers[0].VpcId'))

echo your VpcId is $vpcId

aws elbv2 create-target-group --name $8 --protocol HTTP --port 80 --target-type instance --vpc-id $vpcId

echo Waiting /for load-balancer to be active
echo \ =============================================================== \

aws elbv2 wait load-balancer-available

echo Getting Target Groups ARN and Load Balancer ARN
echo \ =============================================================== \

read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --output text --query TargetGroups[0].[TargetGroupArn]))
read loadBalancerArn < <(echo $(aws elbv2 describe-load-balancers --output text --query LoadBalancers[0].LoadBalancerArn))


echo Registering Target
echo \ =============================================================== \

#Create auto scaling group

#aws autoscaling create-auto-scaling-group --auto-scaling-group-name <auto-scalling-group-name> --launch-configuration-name <launch-configuration-name> --min-size 2 --max-size 6 --desired-capacity 3

aws autoscaling attach-load-balancer-target-groups --auto-scaling-group-name ${10} --target-group-arns targetGroupArn

aws autoscaling attach-load-balancers --load-balancer-names $7 --auto-scaling-group-name ${10}

echo Creating Listener
echo \ =============================================================== \

$(aws elbv2 create-listener --load-balancer-arn $loadBalancerArn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$targetGroupArn)

echo Modifying Target Group
echo \ =============================================================== \

echo $(aws elbv2 modify-target-group --target-group-arn $targetGroupArn  --health-check-protocol HTTP --health-check-port 80)

aws elbv2 describe-target-group-attributes --target-group-arn $targetGroupArn

aws autoscaling create-auto-scaling-group --auto-scaling-group-name ${10} --launch-configuration-name ${11} --min-size 2 --max-size 6 --desired-capacity $2 --vpc-zone-identifier "$3,$4"

echo Finished!!
echo \ =============================================================== \