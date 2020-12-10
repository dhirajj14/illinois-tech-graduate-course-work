# Week-06 Assisgnment

## Important Instuctions

> #### This Final project will take the first DynamoDB Table in the list to save the records.

# 

> #### This Final project will take the first two S3 Buckets from the list as raw and output S3 buckets repectively.

#

### Variables to run the Create-env Script

### $1    ImageID
### $2    Count
### $3)	Subnet 1 (availability zone a for your region) for load balancer
### $4)	Subnet 2 (availability zone b for your region) for load balancer
### $5)	subnet-id for EC2 launch instance (availability zone a) (may or may not be used depending on your design) (For me its 1 as placeholder)
### $6)	Security Group ID
### $7)	Load balancer name
### $8)	Target Group name
### $9)	Key-pair name
### ${10})	auto-scaling-group-name
### ${11})	launch-configuration-name
### ${12})	vpc-id You can have the user prompt this or you can retrieve it (for me I give it 1 as placeholder)
### ${13}) S3 bucket Name
### ${14}) IAM Profile
### ${15}) DynomoDB Name
### ${16}) Ouput S3 BucketName - Thumbnail
### ${17}) AWS Lambda user role 

#

### To execute the script enter the following command

    ./create-env.sh <Image-ID> <Count> <Subnet-1> <Subnet-2> <Subnet-ID - I am not using Subnet ID Provide dummy value> <Security-ID> <Load-Balancer-Name> <Target-Group-Name> <Key-Pair-Name> <Auto-Scaling-group-Name> <Launch-Configuration-Name> <VPC ID - I am getting this Automatically Provide Dummy Value > <S3-Bucket-Name> <IAM-Profile-ARN> <DynamoD-Name> <Output-S3-Bucket> <Lambda ARN>

### Example

`./create-env.sh ami-0e7054d218c36ae8a 3 subnet-b4e11185 subnet-962b57db 1 sg-9abcd0a6 my-load-blc target-group-my windows-laptop-bionic-v2 auto-n launch-1 1 fall2020-dpj arn:aws:iam::355122276479:instance-profile/inclass-2020 dpj09 output-20 arn:aws:iam::355122276479:role/service-role/dpj-inclass2020-lambda`

#

### Publish SNS message 

> #### Please enter the phone number includeing +country code
> Example +11231231234

#

### To view list of raw objects

`domain.com:3300/gallery`

#

### Variables to run the destroy-env Script (Variables should be same as used for creating)

### ${1})	auto-scaling-group-name
### ${2})	launch-configuration-name
### ${3}) DynomoDB Name
### ${4}) S3 bucket Name
### ${5}) Ouput S3 BucketName

#

## Important Instuctions

> ### Deregistering Targets take some time.

### To execute the script enter the following command


    ./destroy-env.sh <Auto-Scaling-group-Name> <Launch-Configuration-Name> <DynamoDB-Name> <S3-Bucket-Name> <Output-S3-Bucket-Name>

### Example

`./destroy-env.sh auto-n launch-1 dpj09 fall2020-dpj output-20`