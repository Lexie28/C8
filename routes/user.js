

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
