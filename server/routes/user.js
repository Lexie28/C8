const express = require("express");
const router = express.Router();

const db = require("../db-config.js");


/**
Retrieves all records from the "user" table using Db.js and sends the result back to the client as a response.
@param {Object} req   const { id } = req.params;
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_users(req, res)
{
        db.select("*").from("user").then((result) => {
          res.send(result)
        })
};


/**
Retrieves a certain user with id from the user table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_user(req, res) {
  const id = req.params.id;

  db.select("*").from("user").where({id: id}).then((result) => {
    res.send(result);
  });
}

/**
Registers a new user in the 'user' table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_registration(req, res) {
  const { name, location, phone_number, email } = req.body;

  db('user')
    .insert({ name, location, phone_number, email })
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
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_like(req, res) {

};

/**
Adds a dislike to the user of a certain user id.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_dislike(req, res) {
  const { id } = req.params;

  db('user')
    .where({ id })
    .increment('user_num_dislikes', 1) // use the `increment` method to add 1 to `num_likes`
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
@param {Object} db - The Db.js instance to perform the database operation.
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
//Get all users in the database
router.get('/user', (req, res) => get_users(req, res));

//Get a specific user from the user table
router.get('/user/:id', (req, res) => get_user(req, res))

//Registering a new user
router.post('/user/user', (req, res) => user_registration(req, res));

//Adding a like (/thumbs up) to a user
router.patch('/user/:id/like', (req, res) => user_like(req, res));

//Adding a dislike (/thumbs down) to a user
router.patch('/user/:id/dislike', (req, res) => user_dislike(req, res));

//Deleting user
router.delete('/user/:id', (req, res) => user_delete(req, res));

module.exports = router;

