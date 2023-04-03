export { get_user_with_products }


/**
Retrieves the user of a certain user_id from the user table, together with all their products (corresponding user_id) in the
product table. Useful for profile page where all user info is displayed and all of the products listed.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_user_with_products(req, res, knex) {
    const user_id = req.params.user_id;

    knex.select('*')
      .from('user')
      .where('user.user_id', '=', user_id)
      .then(userResults => {
        const user = userResults[0];
        knex.select('*')
          .from('product')
          .where('product.user_id', '=', user_id)
          .then(productResults => {
            user.products = productResults;
            res.send(user);
          })
          .catch(err => {
            console.error(err);
            res.status(500).json({ message: 'An error occurred while retrieving the user\'s products' });
          });
      })
      .catch(err => {
        console.error(err);
        res.status(500).json({ message: 'An error occurred while retrieving the user' });
      });
  }