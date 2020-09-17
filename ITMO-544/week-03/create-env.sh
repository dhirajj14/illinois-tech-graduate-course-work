#!/bin/bash

read instanceID dns < <(echo $(aws ec2 run-instances --image-id ami-06b263d6ceff0b3dd --instance-type t2.micro --user-data file://install_apache.sh | jq --raw-output '.Instances[0].InstanceId, .Instances[0].InstanceId'))
echo This is ${instanceID}
echo This is dns ${dns}