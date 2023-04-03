export { product_get, product_create, edit_product_all, product_delete }


/**
Retrieves all records from the "product" table using Knex.js and sends the result back to the client as a response.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function product_get(req, res, knex) {
    knex.select("*").from("product").then((result) => {
      res.send(result)
    })
}

/**
Creates a new product using imput received from the client.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function product_create(req, res, knex) {
  const { user_id, product_name, product_description, product_category } = req.body;

  knex('product')
    .insert({ user_id, product_name, product_description, product_category })
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
};

/**
Edits all editable fields in a product (name, description and category)
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function edit_product_all(req, res, knex) {
  const { product_id } = req.params;
  const { product_name, product_description, product_category } = req.body;

  knex('product')
    .where({ product_id })
    .update({ product_name, product_description, product_category })
    .then(result => {
      if (result === 1) {
        res.status(200).json({ message: 'Product updated successfully' });
      } else {
        res.status(404).json({ message: 'Product not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while updating the product' });
    });
};

/**
Deletes a product from the 'product' table.
@param {Object} req - The request object from the client.
@param {Object} res - The response object to send data back to the client.
@param {Object} knex - The Knex.js instance to perform the database operation.
@returns {undefined} This function does not return anything.
*/
function product_delete(req, res, knex) {
  const { product_id } = req.params;

  knex('product')
    .where({ product_id })
    .del()
    .then(result => {
      if (result) {
        res.status(200).json({ message: 'Product deleted successfully' });
      } else {
        res.status(404).json({ message: 'Product not found' });
      }
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ message: 'An error occurred while deleting the product' });
    });
};