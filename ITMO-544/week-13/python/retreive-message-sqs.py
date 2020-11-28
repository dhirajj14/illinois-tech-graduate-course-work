import boto3
import mysql.connector

sqs = boto3.resource('sqs',region_name='us-east-1')

client = boto3.client('rds')

bucketNames = s3.buckets.all()

bucketName = bucketNames[0].name
# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html#processing-messages
# Get the queue
queue = sqs.get_queue_by_name(QueueName='myqueue')


response = client.describe_db_instances(
    DBInstanceIdentifier='string',
    MaxRecords=1,
)

ENDPOINT = response.get('DBInstances')[0].get('Endpoint').get('Address')
PORT = 3306
ZONE = response.get('DBInstances')[0].get('Endpoint').get('HostedZoneId')
DBNAME = "company"
USER = "admin"
PASSWORD = "dhirajj123"
### Connect to Mysql Database and retrieve record relating to the SQS job
# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/rds.html
# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/rds.html#RDS.Client.describe_db_instances
# https://dev.mysql.com/doc/connector-python/en/    


try:
  cnx = mysql.connector.connect(user=USER, password=PASSWORD, database=DBNAME, host=ENDPOINT, port = PORT)
except Exception as e:
  print("Database Failed to connect".format(e))
#  SELECT * FROM jobs WHERE id == message.body;


mycursor = cnx.cursor()

# Process messages by printing out body and optional author name
for message in queue.receive_messages():
  # Print out the body and author (if set)
  print(message.body)                 
  mycursor.execute("SELECT * FROM jobs WHERE id == message.body")
  myresult = mycursor.fetchall()

  for x in myresult
    s3.download_file(bucketName, 'ch-05-files-location.png', 'current-image.jpg')




# Retreive image from the S3 bucket
# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-example-download-file.html
# use sample code from download-s3-bucket-image.py

# Process image with PIL 
# use sample code from render-image.py

# Put Image Object back into S3 Bucket
# use source code from upload-image-to-s3.py

 # SQL UPDATE record where id == message.body  set Stat from 0 to 1
# https://dev.mysql.com/doc/connector-python/en/    

# Let the queue know that the message is processed
message.delete()