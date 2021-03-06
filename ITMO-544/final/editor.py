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
    
    dynamoclient = boto3.client('dynamodb', 'us-east-1')

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
 

    response = dynamoclient.list_tables(
    )

    print(response)
    table = dynamodb.Table(response['TableNames'][0])

    phone=""
    s3url=""
    name=""
    # Process messages by printing out body and optional author name
    for message in event['Records']:
    # Print out the body and author (if set)
        print(message['body'])
        msg = str(message['body'])
        response = table.get_item(Key={'RecordNumber': msg})
        if('Item' in response):
            print( response['Item'])
            data= response['Item']
            phone=data['Phone']
            name=data['CustomerName']
            s3url=data['S3URL']
            fileName = urlparse(s3url)
            components = fileName.path
            components = components[1:]
            s3Client.download_file(bucketName, components, "/tmp/"+components)
            im = Image.open("/tmp/"+components)
            size = (100, 100)
            im.thumbnail(size, Image.ANTIALIAS)
            background = Image.new('RGBA', size, (255, 255, 255, 0))
            background.paste(
            im, (int((size[0] - im.size[0]) / 2), int((size[1] - im.size[1]) / 2))
            )
            background.save("/tmp/thumbnail-"+components)

            s3.Object(outputBucketName, "thumbnail-"+msg+".jpg").upload_file("/tmp/thumbnail-"+components)
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
            
        else:
            print("No Pending Item")
    
        response = client.publish(
                    PhoneNumber=phone,
                    Message="Hello "+name+" Your image has been rendered",
                    Subject="Your Image is ready!"
                )

            