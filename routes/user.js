

//get user

function get_users()
{
    app.get('/users', (req, res) => {
        knex.select("*").from("user").then((result) => {
          res.send(result)
        })
      });
}

module.exports = {
    get_users
  };


//user registration
function userreg() {
app.post('/user/registration', (req, res) => {
    const { user_name } = req.body;
    
    knex('user')
      .insert({ user_name })
      .then(result => {
        if (result) {
          res.status(200).json({ message: 'Product created successfully' });
        } else {
          res.status(500).json({ message: 'An error occurred while creating the product' });
        }
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({ message: 'An error occurred while creating the product' });
      });
  })};