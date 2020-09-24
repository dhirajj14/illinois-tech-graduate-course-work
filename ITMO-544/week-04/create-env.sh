#!/bin/bash

echo Installing jq package to parse instanceID
echo \ =============================================================== \

sudo apt-get install jq

echo jq Installed successfully
echo \ =============================================================== \

echo Creating your EC2 Instance
echo \ =============================================================== \

read instanceID1 instanceID2 instanceID3 < <(echo $(aws ec2 run-instances --image-id ami-06b263d6ceff0b3dd --instance-type t2.micro --security-group-ids sg-9abcd0a6 --key-name windows-laptop-bionic-v2 --user-data file://install_apache.txt --count 3 --output text --query 'Instances[*].InstanceId'))

read dns1 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID1} --query 'Reservations[0].Instances[0].PublicDnsName'))
read dns2 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID2} --query 'Reservations[0].Instances[0].PublicDnsName'))
read dns3 < <(echo $(aws ec2 describe-instances --instance-ids ${instanceID3} --query 'Reservations[0].Instances[0].PublicDnsName'))

echo Your Instance ID is ${instanceID1}
echo Your Instance ID is ${instanceID2}
echo Your Instance ID is ${instanceID3}
echo \ =============================================================== \

echo Creating....Initializing...Starting you EC2 Instance
echo \ =============================================================== \

aws ec2 wait instance-running --instance-ids $instanceID1 $instanceID2 $instanceID3 

read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --query TargetGroups[0].[TargetGroupArn]))
read loadBalancerArn < <(echo $(aws elbv2 describe-target-groups --query TargetGroups[0].LoadBalancerArns[0]))

aws elbv2 create-listener --load-balancer-arn $loadBalancerArn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$targetGroupArn

read vpcId < <(echo $(aws elbv2 describe-target-groups --query TargetGroups[0].[VpcId]))

aws elbv2 create-target-group --name my-targets --protocol HTTP --port 80 --target-type instance --vpc-id $vpcId

aws elbv2 register-targets --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3

# while [ "$dns" == "" ]
# do
#     dns=$(aws ec2 describe-instances --instance-ids ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].PublicDnsName')
# done


# status=$(aws ec2 describe-instances --instance-ids  ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].State.Name')


# while [ "$status" != "running" ]
# do
#     status=$(aws ec2 describe-instances --instance-ids  ${instanceID} | jq --raw-output '.Reservations[0].Instances[0].State.Name')
#     echo Initializing.....
# done

# echo \ =============================================================== \
# echo Your Apache server is up and ready to use

# echo \ =============================================================== \
# echo This is dns ${dns}

# echo \ =============================================================== \
# echo Login you into the Instance

# echo \ =============================================================== \
# ssh -i ./windows-laptop-bionic-v2.priv -y ubuntu@${dns}
