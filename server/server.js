import * as product from "./routes/product.js";
import * as user from "./routes/user.js";
import { createRequire } from "module"

const require = createRequire(import.meta.url);

require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const knex = require('knex')({
  client: 'mysql2',
  connection: {
    host: process.env.DATABASE_HOST,
    port: 3306,
    user: 'root',
    password: process.env.DATABASE_PASSWORD,
    database: 'circle8'
  }
});


// Middleware
app.use(bodyParser.json());
app.use(cors());



// Routes
app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});


//-------PRODUCT-------

app.get('/helloworld', (req, res) => product.get_product(req, res, knex));

//Create a new product
app.post('/product/create', (req, res) => {
  const { product_name, product_desc, product_price } = req.body;

  knex('product')
    .insert({ product_name, product_desc, product_price })
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
});


//Editing product
app.patch('/products/:product_id', (req, res) => {
  const { product_id } = req.params;
  const { product_name, product_desc, product_price } = req.body;

  knex('product')
    .where({ product_id })
    .update({ product_name, product_desc, product_price })
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
});


//Deleting product
app.delete('/product/delete/:product_id', (req, res) => {
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
});



//------- USER -------



//app.route("/user").get(users.getUsers).post(users.addUser);
//const user = require("./routes/user");
//app.route("/users").get(user.get_users);

//Get all users in the database
app.get('/user/users', (req, res) => {
  knex.select("*").from("user").then((result) => {
    res.send(result)
  })
});


//Registering a new user
app.post('/user/registration', (req, res) => {
  const { user_name } = req.body;

  knex('user')
    .insert({ user_name })
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
});


//Adding a like (/thumbs up) to a user
app.patch('/user/like/:user_id', (req, res) => {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
    .increment('num_likes', 1) // use the `increment` method to add 1 to `num_likes`
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
});


//Adding a dislike (/thumbs down) to a user
app.patch('/user/dislike/:user_id', (req, res) => {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
    .increment('num_dislikes', 1) // use the `increment` method to add 1 to `num_likes`
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
});


//Deleting user
app.delete('/user/delete/:user_id', (req, res) => {
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
});

//-----------------

app.post('/login', (req, res) => {
  // Handle user login
});

app.post('/articles', (req, res) => {
  const article = req.body
  // Handle article creation
});

app.post('/transactions', (req, res) => {
  // Handle transaction initiation
});

app.patch('/transactions/:id', (req, res) => {
  // Handle transaction completion
});

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
