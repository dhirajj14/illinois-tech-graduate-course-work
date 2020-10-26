#!/bin/bash

sudo apt-get update

sudo apt-get install -y apache2

sudo systemctl start apache2

sudo apt-get install -y npm

sudo apt-get install -y nodejs

npm install -y express aws-sdk multer multer-s3

git clone https://github.com/dhirajj14/node-app

node node-app/app.js