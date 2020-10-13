# Week-05 Assisgnment

## Important Instuctions


**In my Install-env Script I am using git clone to to get the app.js and index.html which are stored in github public repo due to authentication problem for time being**

**I am automatically getting the s3 bucket name in app.js using the s3.listbucket fuction and scraping data from it. For me I have only one bucket so my next step is to allow user to confirm the bucket name**


### Variables to run the Create-env Script

 $1    ImageID

 $2    Count

 $3)	Subnet 1 (availability zone a for your region) for load balancer

 $4)	Subnet 2 (availability zone b for your region) for load balancer

 $5)	subnet-id for EC2 launch instance (availability zone a) (may or may not be used depending on your design) (Not- Using Provide Dummy Value)

 $6)	Security Group ID

 $7)	Load balancer name

 $8)	Target Group name

 $9)	Key-pair name

 ${10})	auto-scaling-group-name

 ${11})	launch-configuration-name

 ${12})	vpc-id You can have the user prompt this or you can retrieve it

 ${13}) Instance Resourse Tag
 
 ${14}) S3 bucket Name
 
 ${15}) IAM Profile

#

### To execute the script enter the following command

    ./create-env.sh <Image-ID> <Count> <Subnet-1> <Subnet-2> <Subnet-ID - I am not using Subnet ID Provide dummy value> <Security-ID> <Load-Balancer-Name> <Target-Group-Name> <Key-Pair-Name> <Auto-Scaling-group-Name> <Launch-Configuration-Name> <VPC ID - I am getting this Automatically Provide Dummy Value > <Instance-Tag-Name> <S3-Bucket-Name> <IAM-Profile-ARN>

### Variables to run the destroy-env Script (Variables should be same as used for creating)

 $1)	auto-scaling-group-name

 $2)	launch-configuration-name

 $3)	Instance Resource Tag

 $4)    Bucket Name to be deleted

#

### To execute the script enter the following command


    ./destroy-env.sh <Auto-Scaling-group-Name> <Launch-Configuration-Name> <Instance-Tag-Name> <Bucket-Name>

