import boto3
import os
import sys
import uuid
from urllib.parse import unquote_plus
from PIL import Image, ImageFilter
import PIL.Image
import mysql.connector


#s3_client = boto3.client('s3')

client = boto3.client('sns','us-east-1')

dynamodb = boto3.resource('dynamodb', endpoint_url="https://dynamodb.us-east-1.amazonaws.com")

sqs = boto3.resource('sqs',region_name='us-east-1')

bucketNames = s3.buckets.all()

bucketName = bucketNames[0].name

outputBucketName = bucketNames[1].name

# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html#processing-messages
# Get the queue
queue = sqs.get_queue_by_name(QueueName='myqueue')

dynamodb = boto3.resource('dynamodb', endpoint_url="https://dynamodb.us-east-1.amazonaws.com")

table = dynamodb.Table('company')

phone=""
s3url=""
name=""
# Process messages by printing out body and optional author name
for message in queue.receive_messages():
  # Print out the body and author (if set)
    print(message.body)
    msg = message.body

    try:
        response = table.get_item(Key={'RecordNumber': msg})
        data= response['Items']
        phone=data[0]['Phone']
        name=data[0]['CustomerName']
        s3url=data[0]['S3URL']
        fileName = urlparse(x[6])
        components = fileName.path
        components = components[1:]
        s3Client.download_file(bucketName, components, components)
        im = Image.open( components)
        size = (100, 100)
        im.thumbnail(size, Image.ANTIALIAS)
        background = Image.new('RGBA', size, (255, 255, 255, 0))
        background.paste(
        im, (int((size[0] - im.size[0]) / 2), int((size[1] - im.size[1]) / 2))
        )
        background.save("thumbnail-"+components)

        s3.Object(outputBucketName, "rendered-"+msg).upload_file("thumbnail-"+msg)
        response = table.update_item(
            Key={
            'RecordNumber': msg,
            },
            UpdateExpression="set Stat=:s",
            ExpressionAttributeValues={
                ':s': 1,

            },
            ReturnValues="UPDATED_NEW"
        )
        response = client.publish(
            PhoneNumber=phone,
            Message=name,
            Subject="Your Image is ready!"
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
    

    message.delete()

