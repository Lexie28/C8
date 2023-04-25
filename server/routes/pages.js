const express = require("express");
const router = express.Router();

const db = require("../db-config.js");



/**
Retrieves the user of a certain id from the user table, together with all their listings (corresponding id) in the
listing table. Useful for profile page where all user info is displayed and all of the listings listed.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} db - The Db.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_user_with_listings(req, res) {
    const id = req.params.id;

    db.select('*')
      .from('user')
      .where('user.id', '=', id)
      .then(userResults => {
        const user = userResults[0];
        db.select('*')
          .from('listing')
          .where('listing.id', '=', id)
          .then(listingResults => {
            user.listings = listingResults;
            res.send(user);
          })
          .catch(err => {
            console.error(err);
            res.status(500).json({ message: 'An error occurred while retrieving the user\'s listings' });
          });
      })
      .catch(err => {
        console.error(err);
        res.status(500).json({ message: 'An error occurred while retrieving the user' });
      });
}

//your own profile page, retrieves your user information and all of your listings (aka. listings with your id)
//TODO: Kanske inte ha API endpoints för varje sida då det gör det betydligt svårare för frontend att göra förändringar i gränssnitt
router.get('/pages/profilepage/:id', (req, res) => get_user_with_listings(req, res));

module.exports = router;
