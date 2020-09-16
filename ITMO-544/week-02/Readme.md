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