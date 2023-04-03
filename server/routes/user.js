
export { get_users, user_registration, user_like, user_dislike, user_delete }

//get user
function get_users(req, res, knex)
{
        knex.select("*").from("user").then((result) => {
          res.send(result)
        })
};

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

function user_like(req, res, knex) {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
    .increment('user_num_likes', 1) // use the `increment` method to add 1 to `num_likes`
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'User likes updated successfully' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the user likes' });
    });
};

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