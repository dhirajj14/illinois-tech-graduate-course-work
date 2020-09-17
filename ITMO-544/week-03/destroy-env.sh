echo enter you instanceID
read instanceID
aws ec2 terminate-instances --instance-ids ${instanceID}