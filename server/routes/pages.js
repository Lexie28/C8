export { get_user_with_products }



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