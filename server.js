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
    database : 'circle8'
  }
});

// Middleware
app.use(bodyParser.json());
app.use(cors());


const product = {
  product_name: "Äpple",
  product_desc: "God",
  product_price: 100
}

// Routes
app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});

app.get('/helloworld', (req, res) => {
  knex.select("*").from("product").then((result) => {
    res.send(result)
  })
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
