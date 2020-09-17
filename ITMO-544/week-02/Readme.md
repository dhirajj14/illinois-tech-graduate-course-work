# Week - 02 Assignment

## Part 1 

To change the name of the hostname execute the following command                                
`$ sudo hostnamectl set-hostname dpj-itmo-544`

To change the name of the hostname execute the following command  
`$ aws --version`

![aws-version](https://user-images.githubusercontent.com/54300222/93280176-9aa2d200-f78e-11ea-803f-7abde4faedc7.PNG)

## Part 2

To create non-root user for aws execute the following steps:
    
1. Go to IAM Console, and in the left pannel click on the users.
2. Click on the add User blue button
3. Enter the user name and select the access types according to your preferences.
4. Add user to group. Either add to exsisting group or create a new group
    * For me I have given PowerUserAccess to the group
5. Add tags to the user in the key value format
6. Click on create user

![aws-non-root-account](https://user-images.githubusercontent.com/54300222/93280660-c96d7800-f78f-11ea-8f2b-bf209e69585d.PNG)

## Part 3


command to launch the EC2 instance

![launch instance](https://user-images.githubusercontent.com/54300222/93422463-72dc6880-f879-11ea-9068-507f064d3cc8.PNG)

command to check the status of the EC2 instance (Show it is running)

![running instance](https://user-images.githubusercontent.com/54300222/93422478-7839b300-f879-11ea-91af-c7a7e689439c.PNG)

command to destroy the EC2 instance

![terminate](https://user-images.githubusercontent.com/54300222/93422485-7a9c0d00-f879-11ea-9aef-81fe9453965b.PNG)

command to check the status of the EC2 instance (Show it is terminating or terminated)

![terminated](https://user-images.githubusercontent.com/54300222/93422491-7c65d080-f879-11ea-8806-9b7aa234faaa.PNG)

