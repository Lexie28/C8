const express = require("express");
const router = express.Router();

const db = require("../db-config.js");

/**
Retrieves all records from the "listing" table using Db.js and sends the result back to the client as a response.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_listings(req, res) {
    db.select("*").from("listing").then((result) => {
      res.send(result)
    })
}


/**
Gets a  listing of a certain id
 @param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
/*
function get_listing(req, res) {
  const id = req.params.id;

  db.select("*").from("listing").where({id: id}).then((result) => {
    res.send(result);
  });
}*/

function get_listing(req, res) {
  const id = req.params.id;

  db
    .select("*")
    .from("listing")
    .where({ id: id })
    .then((listing) => {
      if (listing.length === 0) {
        res.status(404).send("Listing not found");
      } else {
        const id = listing[0].id;
        db
          .select("*")
          .from("user")
          .where({ id: id })
          .then((user) => {
            if (user.length === 0) {
              res.status(404).send("User not found");
            } else {
              const listingWithUser = { ...listing[0], user: user[0] };
              res.send(listingWithUser);
            }
          })
          .catch((err) => {
              res.status(500).send("Error retrieving user.");
	      	      console.log(err);
          });
      }
    })
    .catch((err) => {
	res.status(500).send("Error retrieving listing");
		      console.log(err);
    });
}

/**
Creates a new listing using imput received from the client.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_create(req, res) {
    const { id, name, description, category, image_path, owner_id } = req.body;

  db('listing')
	.insert({ id, name, description, category, image_path, owner_id})
    .then(result => {
      if (result) {
        res.status(200).json({ message: 'listing created successfully' });
      } else {
        res.status(500).json({ message: 'An error occurred while creating the listing' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while creating the listing' });
    });
};

/**
Edits all editable fields in a listing (name, description and category)
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function edit_listing_all(req, res) {
  const { id } = req.params;
  const { name, description, category } = req.body;

  db('listing')
    .where({ id })
	.update({ name, description, category, image_path })
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'listing updated successfully' });
      } else {
        res.status(404).json({ message: 'listing not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the listing' });
    });
};

/**
Deletes a listing from the 'listing' table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_delete(req, res) {
  const { id } = req.params;

  db('listing')
    .where({ id })
    .del()
    .then(result => {
      if (result) {
        res.status(200).json({ message: 'listing deleted successfully' });
      } else {
        res.status(404).json({ message: 'listing not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while deleting the listing' });
    });
};

/**
Retrieves the 5 most pooular listings based on number of bids
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_top5popular(req, res) {
  db.select('*')
    .from('listing')
    .orderBy('num_bids', 'desc')
    .limit(5)
    .then(top5listings => {
      res.status(200).json(top5listings);
    })
    .catch(err => {
      console.error(err);
      res.status(500).json({ message: 'An error occurred while retrieving the top 5 listings' });
    });
}

/**
Retrieves all listings in order of popularity based on number of bids
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_popular(req, res) {
  db.select('*')
    .from('listing')
    .orderBy('num_bids', 'desc')
    .then(popularlistings => {
      res.status(200).json(popularlistings);
    })
    .catch(err => {
      console.error(err);
      res.status(500).json({ message: 'An error occurred while retrieving the top 5 listings' });
    });
}
//TODO: Pagination så att inte alla kommer upp at once

/**
Increases the number of bids on a certain listing by 1.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_bid(req, res) {
  const { id } = req.params;

  db('listing')
    .where({ id })
    .increment('num_bids', 1) // use the `increment` method to add 1 to `num_bids`
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'listing number of bids updated successfully' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the user dislikes' });
    });
}


/**
Retrieves all listings of a certain category
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_category(req, res) {
  const { category } = req.params;

  db.select('*')
    .from('listing')
    .where('listing.category', '=', category)
    .then(categorylistings => {
      res.status(200).json(categorylistings);
    })
    .catch(err => {
      console.error(err);
      res.status(500).json({ message: 'An error occurred while retrieving the listings of this category' });
    });
}


router.get("/listing", get_listings);

router.get('/listing/:id', (req, res) => get_listing(req, res));

router.post('/listing', (req,res) => listing_create(req, res));

router.patch('/listing/:id', (req, res) => edit_listing_all(req, res));

router.delete('/listing/:id', (req, res) => listing_delete(req, res));

//Retrieve the 5 most popular listings
router.get('/listing/top5popular', (req, res) => listing_top5popular(req, res));

//Retrieve the listings in order of popularity based on number of bids
router.get('/listing/popular', (req, res) => listing_popular(req, res));

//Updates number of bid by 1 for a certain id
//TODO: ta bort pga onödig?
router.patch('/listing/:id/update_bid', (req, res) => listing_bid(req, res));

//Retrieves all items of a certain category
//TODO: byt ut mot query string istället för att ha endpoint
router.get('/listing/category/:listing_category', (req, res) => listing_category(req, res));

module.exports = router;
