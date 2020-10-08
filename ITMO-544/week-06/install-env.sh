#!/bin/bash

sudo apt-get update

sudo apt-get install -y apache2

sudo systemctl start apache2

sudo apt-get install -y npm

sudo apt-get install -y nodejs

npm install -y express aws-sdk multer multer-s3