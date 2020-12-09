// Install these packages via npm: npm install express aws-sdk multer multer-s3

const path = require('path');
const fs = require('fs');

var express = require('express'),
    aws = require('aws-sdk'),
    bodyParser = require('body-parser'),
    multer = require('multer'),
    multerS3 = require('multer-s3');
    

// needed to include to generate UUIDs
// https://www.npmjs.com/package/uuid
const { v4: uuidv4 } = require('uuid');

aws.config.update({
    region: 'us-east-1'
});

// initialize an s3 connection object

var sqsURL ="";
var app = express(),
    s3 = new aws.S3();

    // Code to get SQS URL
    var sqs = new aws.SQS({apiVersion: '2012-11-05'});

    var params = {
      QueueName: 'myqueue'
    };
    
    var sqsURL = "";
    sqs.getQueueUrl(params, function(err, data) {
      if (err) {
        console.log("Error", err);
      } else {
        console.log("Success", data.QueueUrl);
        sqsURL = data.QueueUrl;
      }
    });


// configure S3 parameters to send to the connection object
app.use(bodyParser.json());


var promise = new Promise(function(resolve, reject) { 
  s3.listBuckets(function(err, data) {
  if (err) console.log(err, err.stack); // an error occurred
   else resolve(data.Buckets[0].Name);           // successful response
  });
}).catch((error) => {
  console.error(error);
});

var d1 = "";
console.log(promise);

promise.then((value) => {
  d1 = value;
  var upload = multer({
    storage: multerS3({
        s3: s3,
        bucket: value,
        key: function (req, file, cb) {
            cb(null, file.originalname);
            }
        })
    });
    console.log(value);
  
  // initialize an DynomoDB object
  var docClient = new aws.DynamoDB.DocumentClient();

  var table = "	dynomo-dpj";

  app.get('/', function (req, res) {
      res.sendFile(__dirname + '/index.html');
  });

  app.post('/upload', upload.array('uploadFile',1), function (req, res, next) {

  // https://www.npmjs.com/package/multer
  // This retrieves the name of the uploaded file
  var fname = req.files[0].originalname;
  // Now we can construct the S3 URL since we already know the structure of S3 URLS and our bucket
  // For this sample I hardcoded my bucket, you can do this or retrieve it dynamically
  var s3url = `https://${d1}.s3.amazonaws.com/` + fname;
  // Use this code to retrieve the value entered in the username field in the index.html
  var username = req.body['name'];
  // Use this code to retrieve the value entered in the email field in the index.html
  var email = req.body['email'];
  // Use this code to retrieve the value entered in the phone field in the index.html
  var phone = req.body['phone'];
  // generate a UUID for this action
  var id = uuidv4();


  var params = {
    TableName:table,
    Item:{
        "Email": email,
        "S3URL": s3url,
        "RecordNumber": id,
        "CustomerName": username,
        "Phone": phone,
        "Stat": 0 
    }
  };

    console.log("Adding a new item...");
    docClient.put(params, function(err, data) {
        if (err) {
            console.error("Unable to add item. Error JSON:", JSON.stringify(err, null, 2));
        } else {
            console.log("Added item:", JSON.stringify(data, null, 2));
            var SQSparams = {
              // Remove DelaySeconds parameter and value for FIFO queues
            DelaySeconds: 0,
            MessageBody: id,
            // MessageDeduplicationId: "TheWhistler",  // Required for FIFO queues
            // MessageGroupId: "Group1",  // Required for FIFO queues
            QueueUrl: sqsURL
            };

            sqs.sendMessage(SQSparams, function(err, data) {
              if (err) {
                console.log("Error", err);
              } else {
                console.log("Success", data.MessageId);
                // Write output to the screen
              res.write(s3url + "\n");
              res.write(username + "\n")
              res.write(fname + "\n");
              res.write("File uploaded successfully to Amazon S3 Server!" + "\n");
              res.end();
              }
            });
        }
      });


  });

}).catch((error) => {
  console.error(error);
});

app.listen(3300, function () {
    console.log('Amazon s3 file upload app listening on port 3300');
});