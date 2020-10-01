echo Getting your elbv2 and ec2 information data to delete 
echo \ =============================================================== \


read instanceID1 instanceID2 instanceID3 < <(echo $(aws ec2 describe-tags --filters 'Name=tag:Name,Values='$3'' --output text --query 'Tags[*].ResourceId'))


read targetGroupArn < <(echo $(aws elbv2 describe-target-groups --output text --query TargetGroups[0].[TargetGroupArn]))
read loadBalancerArn < <(echo $(aws elbv2 describe-load-balancers --output text --query LoadBalancers[0].LoadBalancerArn))
read listenerArn < <(echo $(aws elbv2 describe-listeners --load-balancer-arn $loadBalancerArn --output text --query Listeners[0].ListenerArn))

echo Deregistering Targets
echo \ =============================================================== \

aws elbv2 deregister-targets --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3

aws elbv2 wait target-deregistered --target-group-arn $targetGroupArn --targets Id=$instanceID1 Id=$instanceID2 Id=$instanceID3,Port=80


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

echo $(aws ec2 terminate-instances --instance-ids $instanceID1 $instanceID2 $instanceID3)

aws ec2 wait instance-terminated --instance-ids $instanceID1 $instanceID2 $instanceID3

echo All resources have been terminated
echo \ =============================================================== \

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $1 --force-delete

aws autoscaling delete-launch-configuration --launch-configuration-name $2


echo Finished!!!
echo \ =============================================================== \