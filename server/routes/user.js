const express = require("express");
const router = express.Router();
const fs = require("fs");

const db = require("../db-config.js");

require('dotenv').config();
const{ PutObjectCommand, S3Client } = require("@aws-sdk/client-s3");

// Create an Amazon S3 service client object.
const s3Client = new S3Client({ region: "eu-north-1" });
//TODO: Gör s3Client singleton så att det inte behöver skapas en ny för varje request till den.

//OBSOBS denna logik fungerar endast för profilbilden eftersom varje användare endast har 1 profilbild
async function uploadPic(file_path, id) {
  fs.readFile(file_path, async (err, pic_data) => {
    if (err) throw err;
    
    // Set the parameters
    const s3Params = {
      Bucket: process.env.S3_BUCKET,
      Key: id + ".png", //TODO: supporta fler filtyper??
      Body: pic_data, // The content of the object. For example, 'Hello world!".
    };
    // Create an object and upload it to the Amazon S3 bucket.
    try {
      const results = await s3Client.send(new PutObjectCommand(s3Params)); // <-Viktigt att sätta alla fälten i 'params' så det blir rätt här
      console.log(
        "Successfully created " +
        s3Params.Key +
        " and uploaded it to " +
        s3Params.Bucket +
        "/" +
        s3Params.Key
        );
        return results; // For unit tests.
      } catch (err) {
        console.log("Error", err);
      }
    });
};

/**
Retrieves all records from the "user" table using Db.js and sends the result back to the client as a response.
@param {Object} req   const { id } = req.params;
@param {Object} res - The response object to send data back to the client.
@returns {undefined} This function does not return anything.
*/
function get_users(req, res)
{
        db.select("*").from("user").then((result) => {
          res.send(result)
        })
};


/**
Registers a new user in the 'user' table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@returns {undefined} This function does not return anything.
*/
function user_registration(req, res) {
    const { id, name, profile_picture_path, phone_number, email, location } = req.body;

  uploadPic(id,profile_picture_path);
  profile_picture_path = id + ".png";
  db('user')
	.insert({id, name, profile_picture_path, phone_number, email, location})
    .then(result => {
      if (result) {
        res.status(200).json({ message: 'User created successfully' });
      } else {
        res.status(500).json({ message: 'An error occurred while creating the user' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while creating the user' });
    });
};

/**
Adds a like to the user of a certain user id.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@returns {undefined} This function does not return anything.
*/
function user_like(req, res) {
  const { id } = req.params;

  db('user')
    .where({ id })
    .increment('likes', 1) // use the `increment` method to add 1 to `num_likes`
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'User dislikes updated successfully' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the user dislikes' });
    });
};

/**
Adds a dislike to the user of a certain user id.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@returns {undefined} This function does not return anything.
*/
function user_dislike(req, res) {
  const { id } = req.params;

  db('user')
    .where({ id })
    .increment('dislikes', 1) // use the `increment` method to add 1 to `num_likes`
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'User dislikes updated successfully' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the user dislikes' });
    });
};

/**
Deletes a user of a certain user id.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.

@returns {undefined} This function does not return anything.
*/
function user_delete(req, res) {
  const { id } = req.params;

  db('user')
    .where({ id })
    .del()
    .then(result => {
      if (result) {
        res.status(200).json({ message: 'User deleted successfully' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while deleting the user' });
    });
};


function user_exists(req, res) {
  const { id } = req.params;

  db('user')
    .select('id')
    .where({ id })
    .first()
    .then(result => {
      if (result) {
        res.status(200).json({ message: 'User found' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while checking for user existence' });
    });
};


//Get all users in the database
router.get('/user', (req, res) => get_users(req, res));

//Get a specific user from the user table
router.get('/user/:id', (req, res) => get_users(req, res))

//Registering a new user
router.post('/user', (req, res) => user_registration(req, res));

//Adding a like (/thumbs up) to a user
router.patch('/user/:id/like', (req, res) => user_like(req, res));

//Adding a dislike (/thumbs down) to a user
router.patch('/user/:id/dislike', (req, res) => user_dislike(req, res));

//Deleting user
router.delete('/user/:id', (req, res) => user_delete(req, res));

router.get("/user/:id/offers", async (req, res) => {
    //TODO: flytta implementationen från offer.js hit    
});

router.post("/user/exists/:id", (req, res) => user_exists(req, res));


module.exports = router;

/*
    
*/
