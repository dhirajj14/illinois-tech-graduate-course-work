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
# ${13}) S3 bucket Name
# ${14}) IAM Profile
# ${15}) DynomoDB Name
# ${16}) Ouput S3 BucketName
# ${17}) lambda ARN
# ${18}) Tag


#Create launch Configuration

#create-launch-configuration --launch-configuration-name <launch-configuration-name> --image-id <image-ID> --instance-type t2.micro --security-groups <Security-Group-Name --key-name <key-pair> --user-data file://install-env.sh

echo \ 

echo \ ==========================Creating DynomoBD============================ \

read temp < <(echo $(aws dynamodb create-table --table-name ${15} --attribute-definitions AttributeName=RecordNumber,AttributeType=S --key-schema AttributeName=RecordNumber,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5))

echo \ ==========May take about 10-15 mins to create DynomoBD ============== \

aws dynamodb wait table-exists --table-name ${15}

echo \ =============================================================== \

echo \ ==========================Your sqs queue URL============================ \

read queueURL < <(echo $(aws sqs create-queue --queue-name myqueue --output text --query 'QueueUrl'))

echo $queueURL

echo \ ===============================================================\

echo \ ==========================Getting QueueArn============================ \

read queueARN < <(echo $(aws sqs get-queue-attributes --queue-url $queueURL --attribute-names QueueArn --output text --query Attributes.QueueArn))

echo \ ===============================================================\

echo Opening TCP 3300 port

echo \ =============================================================== \

aws ec2 authorize-security-group-ingress --group-id ${6} --ip-permissions IpProtocol=tcp,FromPort=3300,ToPort=3300,IpRanges='[{CidrIp=0.0.0.0/0}]'

echo \ =============================================================== \

# echo Creating Database

# mysql --host=${rdsEndpoint} -u admin -pdhirajj123 --port=3306< create.sql

# echo \ =============================================================== \

echo \ ==========================Creating Lambda Function============================ \

aws lambda create-function --function-name EditorFunction --runtime python3.6 --zip-file fileb://editor.zip \
    --handler editor.handler --role ${17} --timeout 30

echo \ =============================================================== \

echo \ ==========================Mapping Lambda Function============================ \

aws lambda create-event-source-mapping --function-name EditorFunction --batch-size 5 --maximum-batching-window-in-seconds 60 --event-source-arn $queueARN

echo \ =============================================================== \

echo \ ==========================Creating SNS Topic============================ \

aws sns create-topic --name dpj-sns-topic

echo \ =============================================================== \

echo Creating your EC2 Instance
echo \ =============================================================== \

read instanceID1 instanceID2 instanceID3 < <(echo $(aws ec2 run-instances --image-id $1 --instance-type t2.micro --security-group-ids $6 --key-name $9 --user-data file://install-env.txt --iam-instance-profile Arn=${14} --count $2 --output text --query 'Instances[*].InstanceId'))

aws ec2 wait instance-running --instance-ids $instanceID1 $instanceID2 $instanceID3 

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

aws autoscaling create-launch-configuration --launch-configuration-name ${11} --security-groups $6 --key-name $9 --user-data file://install-env.txt --instance-id $instanceID1

read vpcId < <(echo $(aws elbv2 create-load-balancer --name $7 --subnets $3 $4 --output text  --query 'LoadBalancers[0].VpcId'))

echo your VpcId is $vpcId

aws elbv2 create-target-group --name $8 --protocol HTTP --port 3300 --target-type instance --vpc-id $vpcId

echo Waiting /for load-balancer to be active
echo \ =============================================================== \

aws elbv2 wait load-balancer-available

echo Getting Target Groups ARN and Load Balancer ARN
echo \ =============================================================== \

read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --output text --query TargetGroups[0].[TargetGroupArn]))

read loadBalancerArn < <(echo $(aws elbv2 describe-load-balancers --output text --query LoadBalancers[0].LoadBalancerArn))

echo LoadBalancers Arn $loadBalancerArn

echo Registering Target
echo \ =============================================================== \

$(aws elbv2 register-targets --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3)

#Create auto scaling group

#aws autoscaling create-auto-scaling-group --auto-scaling-group-name <auto-scalling-group-name> --launch-configuration-name <launch-configuration-name> --min-size 2 --max-size 6 --desired-capacity 3

echo Creating Listener
echo \ =============================================================== \

echo $(aws elbv2 create-listener --load-balancer-arn $loadBalancerArn --protocol HTTP --port 3300 --default-actions Type=forward,TargetGroupArn=$targetGroupArn)

echo Modifying Target Group
echo \ =============================================================== \

echo $(aws elbv2 modify-target-group --target-group-arn $targetGroupArn --health-check-protocol HTTP --health-check-port 80)

aws elbv2 describe-target-group-attributes --target-group-arn $targetGroupArn

aws autoscaling create-auto-scaling-group --auto-scaling-group-name ${10} --launch-configuration-name ${11} --min-size 2 --max-size 6 --desired-capacity $2 --vpc-zone-identifier "$3,$4"

echo Creating S3 bucket
echo \ =============================================================== \

aws s3 mb s3://${13}

echo \ =============================================================== \

echo Creating Output Thumbnail S3 bucket
echo \ =============================================================== \

aws s3 mb s3://${16}

echo \ =============================================================== \


echo Finished!!
echo \ =============================================================== \
