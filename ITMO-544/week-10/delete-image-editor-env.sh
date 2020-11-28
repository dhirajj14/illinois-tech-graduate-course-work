echo Getting your ec2 information data to delete 

echo \ =============================================================== \

read instanceID1 < <(echo $(aws ec2 describe-tags --filters 'Name=tag:Name,Values='$3'' --output text --query 'Tags[*].ResourceId'))

echo Deleting EC2 Instance

echo \ =============================================================== \

echo $(aws ec2 terminate-instances --instance-ids $instanceID1)

aws ec2 wait instance-terminated --instance-ids $instanceID1

echo \ =============================================================== \

echo All resources have been terminated

echo \ =============================================================== \

echo Finished!!!

echo \ =============================================================== \