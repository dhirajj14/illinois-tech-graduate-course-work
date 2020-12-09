import boto3
import os
import sys
import uuid
from urllib.parse import urlparse
from PIL import Image, ImageFilter
import PIL.Image


#s3_client = boto3.client('s3')


def handler(event, context):
    print("Hello")
    client = boto3.client('sns','us-east-1')

    dynamodb = boto3.resource('dynamodb', endpoint_url="https://dynamodb.us-east-1.amazonaws.com", region_name="us-east-1")

    sqs = boto3.resource('sqs',region_name='us-east-1')

    s3 = boto3.resource('s3','us-east-1')

    s3Client = boto3.client('s3','us-east-1')
    x=0
    for bucket in s3.buckets.all():
        if(x==0):
            bucketName = bucket.name
        if(x==1):
            outputBucketName = bucket.name
            break
        x =x+1
    # https://boto3.amazonaws.com/v1/documentation/api/latest/guide/sqs.html#processing-messages
    # Get the queue
    queue = sqs.get_queue_by_name(QueueName='myqueue')

    table = dynamodb.Table('dynomo-dpj')

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
            if('Item' in response):
                data= response['Item']
                phone=data['Phone']
                name=data['CustomerName']
                s3url=data['S3URL']
                fileName = urlparse(s3url)
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

                s3.Object(outputBucketName, "thumbnail-"+msg+".jpeg").upload_file("thumbnail-"+components)
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
                message.delete()
            else:
                print("No Pending Item")
        except ClientError as e:
            print("No error")


            