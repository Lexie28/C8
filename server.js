require('dotenv').config()
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const knex = require('knex')({
  client: 'mysql2',
  connection: {
    host : process.env.DATABASE_HOST,
    port : 3306,
    user : 'root',
    password : process.env.DATABASE_PASSWORD,
    database : 'world'
  }
});


// Middleware
app.use(bodyParser.json());
app.use(cors());




// Routes
app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});

app.get('/helloworld', (req, res) => {
  knex.select("*").from("city").then((result) => {
    res.send(result)
  })
});


//Editing product
app.patch('/products/:ID', (req, res) => {
  const { ID } = req.params;
  const { Name, CountryCode, District, Population } = req.body;
  
  knex('world')
    .where({ ID })
    .update({ Name, CountryCode, District, Population })
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



app.post('/register', (req, res) => {
  // Handle user registration
});

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
