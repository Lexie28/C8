
export { get_users, user_registration, user_like, user_dislike, user_delete, get_user }

/**
Retrieves all records from the "user" table using Knex.js and sends the result back to the client as a response.
@param {Object} req   const { user_id } = req.params;
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_users(req, res, knex)
{
        knex.select("*").from("user").then((result) => {
          res.send(result)
        })
};


/**
Retrieves a certain user with user_id from the user table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function get_user(req, res, knex) {
  const user_id = req.params.user_id;

  knex.select("*").from("user").where({user_id: user_id}).then((result) => {
    res.send(result);
  });
}

/**
Registers a new user in the 'user' table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_registration(req, res, knex) {
  const { user_name, user_location, user_phone, user_email } = req.body;

  knex('user')
    .insert({ user_name, user_location, user_phone, user_email })
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_like(req, res, knex) {

};

/**
Adds a dislike to the user of a certain user id.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_dislike(req, res, knex) {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
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
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function user_delete(req, res, knex) {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
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