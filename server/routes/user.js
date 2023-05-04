const express = require("express");
const router = express.Router();

const db = require("../db-config.js");
const {add_listing_objects_to_offer} = require("../utils.js");

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

  db('user')
	.insert({id, name, profile_picture_path, phone_number, email, location})
    .then(result => {
      if (result) {
        res.status(201).json({ message: 'User created successfully' });
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

/*
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/

function get_user(req, res) {
  const { id } = req.params;

  db('user')
  .where({ id })
  .then((result) => {
    res.send(result);
  });
}


function edit_user_all(req, res) {
  const { id } = req.params;
  const { name, profile_picture_path, phone_number, email, location } = req.body;

  db('user')
    .where({ id })
    .update({ name, profile_picture_path, phone_number, email, location })
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'user updated successfully' });
      } else {
        res.status(404).json({ message: 'user not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the user' });
    });
};


//Get all users in the database
router.get('/user', (req, res) => get_users(req, res));

//Checks if user exists
router.post("/user/exists/:id", (req, res) => user_exists(req, res));

//Get a specific user from the user table
router.get('/user/:id', (req, res) => get_user(req, res))

//Registering a new user
router.post('/user', (req, res) => user_registration(req, res));

//Edit all parts of user
router.patch('/user/:id', (req, res) => edit_user_all(req, res));

//Adding a like (/thumbs up) to a user
router.patch('/user/:id/like', (req, res) => user_like(req, res));

//Adding a dislike (/thumbs down) to a user
router.patch('/user/:id/dislike', (req, res) => user_dislike(req, res));

//Deleting user
router.delete('/user/:id', (req, res) => user_delete(req, res));


router.get("/user/:id/offers", async (req, res) => {
    //1. Hitta alla offers där användaren med id är involverad i.
    //   En lista för offers där användaren erbjuder, en annan för där
    //   hen blir erbjuden
    //2. Hitta alla items som är involverade i buden. I varje bud, lägg in
    //   varje item i en lista som antingen är budgivar eller budtagar-items
    const user_id  = req.params.id;

    user_query_result = await db("user").where({id: user_id});
    if (user_query_result.length == 0) {
	res.status(404).json({ message: 'User not found' });
	return;
    }
    
    const offers = new Object();
    
    offers.making_offer =
	await db
	.select("*")
	.from("offer")
	.where("user_making_offer", user_id);

    offers.receiving_offer = 
	await db("offer")
	.select("*")
	.where({user_receiving_offer: user_id});

    for (const offer of offers.making_offer) {
	await add_listing_objects_to_offer(offer);
    }

    for (const offer of offers.receiving_offer) {
	await add_listing_objects_to_offer(offer);
    }

    res.status(200).json(offers);
})


router.get("/user/:id/listings", () => {
  const { id } = req.params;

    db
	.select("*")
	.from("listing")
	.where("owner_id", id)
	.then((result) => {
	    res.status(200).json(result)
	}).catch((err) => {
	    console.log(err);
	    res.status(500).json({message: "Error!" + err})
	});
})

module.exports = router;
