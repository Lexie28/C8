export { get_listings, listing_create, edit_listing_all, listing_delete, listing_top5popular, listing_bid, listing_popular, get_listing, listing_category, listing_user }


/**
Retrieves all records from the "listing" table using Knex.js and sends the result back to the client as a response.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_listings(req, res, knex) {
    knex.select("*").from("listing").then((result) => {
      res.send(result)
    })
}


/**
Gets a  listing of a certain listing_id
 @param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
/*
function get_listing(req, res, knex) {
  const listing_id = req.params.listing_id;

  knex.select("*").from("listing").where({listing_id: listing_id}).then((result) => {
    res.send(result);
  });
}*/

function get_listing(req, res, knex) {
  const listing_id = req.params.listing_id;

  knex
    .select("*")
    .from("listing")
    .where({ listing_id: listing_id })
    .then((listing) => {
      if (listing.length === 0) {
        res.status(404).send("Listing not found");
      } else {
        const user_id = listing[0].user_id;
        knex
          .select("*")
          .from("user")
          .where({ user_id: user_id })
          .then((user) => {
            if (user.length === 0) {
              res.status(404).send("User not found");
            } else {
              const listingWithUser = { ...listing[0], user: user[0] };
              res.send(listingWithUser);
            }
          })
          .catch((err) => {
            res.status(500).send("Error retrieving user");
          });
      }
    })
    .catch((err) => {
      res.status(500).send("Error retrieving listing");
    });
}

/**
Creates a new listing using imput received from the client.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_create(req, res, knex) {
  const { user_id, listing_name, listing_description, listing_category } = req.body;

  knex('listing')
    .insert({ user_id, listing_name, listing_description, listing_category })
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function edit_listing_all(req, res, knex) {
  const { listing_id } = req.params;
  const { listing_name, listing_description, listing_category } = req.body;

  knex('listing')
    .where({ listing_id })
    .update({ listing_name, listing_description, listing_category })
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_delete(req, res, knex) {
  const { listing_id } = req.params;

  knex('listing')
    .where({ listing_id })
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_top5popular(req, res, knex) {
  knex.select('*')
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_popular(req, res, knex) {
  knex.select('*')
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_bid(req, res, knex) {
  const { listing_id } = req.params;

  knex('listing')
    .where({ listing_id })
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function listing_category(req, res, knex) {
  const { listing_category } = req.params;

  knex.select('*')
    .from('listing')
    .where('listing.listing_category', '=', listing_category)
    .then(categorylistings => {
      res.status(200).json(categorylistings);
    })
    .catch(err => {
      console.error(err);
      res.status(500).json({ message: 'An error occurred while retrieving the listings of this category' });
    });
}


function listing_user(req, res, knex) {
  const user_id = req.params.user_id;
  
  knex.select("*").from("listing").where("user_id", user_id).then((result) => {
    res.send(result)
  }).catch((err) => {
    console.log(err);
    res.sendStatus(500);
  });
}