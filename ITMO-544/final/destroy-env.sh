echo Getting your elbv2 and ec2 information data to delete 
echo \ =============================================================== \


read instances < <(echo $(aws ec2 describe-instances --filters Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[*].InstanceId'))



read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --output text --query 'TargetGroups[0].TargetGroupArn'))
read loadBalancerArn < <(echo $(aws elbv2 describe-load-balancers --output text --query 'LoadBalancers[0].LoadBalancerArn'))
read listenerArn < <(echo $(aws elbv2 describe-listeners --load-balancer-arn $loadBalancerArn --output text --query 'Listeners[0].ListenerArn'))

read instanceID1< <(echo $(aws elbv2 describe-target-health --target-group-arn $targetGroupArn  --query 'TargetHealthDescriptions[0].Target.Id'))
read instanceID2< <(echo $(aws elbv2 describe-target-health --target-group-arn $targetGroupArn  --query 'TargetHealthDescriptions[1].Target.Id'))
read instanceID3< <(echo $(aws elbv2 describe-target-health --target-group-arn $targetGroupArn  --query 'TargetHealthDescriptions[2].Target.Id'))

echo Deregistering Targets
echo \ =============================================================== \


aws elbv2 deregister-targets --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3

aws elbv2 wait target-deregistered --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3


echo Deleting listener
echo \ =============================================================== \

aws elbv2 delete-listener --listener-arn $listenerArn

echo Deleting Target Group
echo \ =============================================================== \

aws elbv2 delete-target-group --target-group-arn $targetGroupArn

echo Deleting Load Balancer
echo \ =============================================================== \

aws elbv2 delete-load-balancer --load-balancer-arn $loadBalancerArn

aws elbv2 wait load-balancers-deleted --load-balancer-arns $loadBalancerArn

echo Deleting EC2 Instance
echo \ =============================================================== \

echo $(aws ec2 terminate-instances --instance-ids $instances)

aws ec2 wait instance-terminated --instance-ids $instances

echo \ =============================================================== \

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $1 --force-delete

aws autoscaling delete-launch-configuration --launch-configuration-name $2


echo Deleting DynomoDB Instance

aws dynamodb delete-table --table-name $3

aws dynamodb wait table-not-exists --table-name $3

echo \ =============================================================== \

echo Deleting SQS Queue 
echo \ =============================================================== \

read queueURL < <(echo $(aws sqs get-queue-url --queue-name myqueue --output text --query 'QueueUrl'))

aws sqs delete-queue --queue-url ${queueURL}

echo Deleting Bucket

echo \ =============================================================== \

aws s3 rb s3://${4} --force  

aws s3 rb s3://${5} --force  


echo Deleting Lambda

echo \ =============================================================== \

aws lambda delete-function --function-name EditorFunction

echo Deleting Mapping

echo \ =============================================================== \

read UUID < <(echo $(aws lambda list-event-source-mappings --function-name EditorFunction --output text --query EventSourceMappings[0].UUID))

aws lambda delete-event-source-mapping --uuid $UUID

echo Deleting SNS Topic

echo \ =============================================================== \

read topicARN < <(echo $(aws sns list-topics --output text --query 'Topics[0].TopicArn'))

aws sns delete-topic --topic-arn $topicARN

echo Finished!!! All resources have been terminated/deleted
echo \ =============================================================== \