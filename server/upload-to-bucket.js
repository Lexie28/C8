// Import required AWS SDK clients and commands for Node.js.
require('dotenv').config();
const{ PutObjectCommand, S3Client } = require("@aws-sdk/client-s3");

// Create an Amazon S3 service client object.
const s3Client = new S3Client({ region: "eu-north-1" });

// Set the parameters
const params = {
  Bucket: process.env.S3_BUCKET,
  Key: "sample.txt", // The name of the object. For example, 'sample_upload.txt'.
  Body: "Hello World!", // The content of the object. For example, 'Hello world!".
};

const run = async () => {
  // Create an object and upload it to the Amazon S3 bucket.
  try {
    const results = await s3Client.send(new PutObjectCommand(params)); // <-Viktigt att sätta alla fälten i 'params' så det blir rätt här
    console.log(
        "Successfully created " +
        params.Key +
        " and uploaded it to " +
         params.Bucket +
        "/" +
        params.Key
    );
    return results; // For unit tests.
  } catch (err) {
    console.log("Error", err);
  }
};
run();
