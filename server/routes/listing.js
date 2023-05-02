const express = require("express");
const router = express.Router();
const {currentDateTime, newId, amountOfQueryStrings} = require("../utils.js");



const db = require("../db-config.js");




/**
Retrieves all records from the "listing" table using Db.js and sends the result back to the client as a response.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@returns {undefined} This function does not return anything.
*/
async function get_listings(req, res) {

    /*
      #swagger.description = 'Gets all listings. Use query strings to filter and sort. \\nPossible values for sort: popular.'
    */
    var all_listings = db.select("*").from("listing");
    
    if(amountOfQueryStrings(req) === 0) {
	res.send(await all_listings);
	return;
    }
 

    //Query strings
    var result = all_listings;
    
    if(req.query.category != undefined) {
	result = result.where({category: req.query.category});
    }

    const sort = req.query.sort;
    if(sort != undefined) {
	if(sort === "popular") {
	    result = result.orderBy('number_of_bids');
	}
    }

    const amount = req.query.amount;
    //TODO: edge case om amount inte är ett positivt heltal
    if(amount != undefined) {
	result = result.limit(amount);
    }

    result = await result;
    res.send(result);
}


/**
Gets a  listing of a certain id
 @param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@returns {undefined} This function does not return anything.
*/

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
        const owner_id = listing[0].owner_id;
        db
          .select("*")
          .from("user")
          .where({ id: owner_id })
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
@returns {undefined} This function does not return anything.
*/
function listing_create(req, res) {
    const { name, description, category, image_path, owner_id } = req.body;
    const id = newId();
    const creation_date = currentDateTime();
  db('listing')
	.insert({ id, name, description, creation_date, image_path, category, owner_id})
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

    //FIXME: allt som borde försvinna i offer_listing gör inte det
};

function listing_user(req, res) {
  const { id } = req.params;

  db.select("*").from("listing").where("owner_id", id).then((result) => {
    res.send(result)
  }).catch((err) => {
    console.log(err);
    res.sendStatus(500);
  });
}



router.get("/listing", get_listings);

router.get('/listing/category/:category', (req, res) => listing_category(req, res));

router.get('/listing/user/:id', (req, res) => listing_user(req, res));

router.get('/listing/:id', (req, res) => get_listing(req, res));

router.post('/listing', (req,res) => listing_create(req, res));

router.patch('/listing/:id', (req, res) => edit_listing_all(req, res));

router.delete('/listing/:id', (req, res) => listing_delete(req, res));

module.exports = router;