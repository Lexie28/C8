import * as product from "./routes/product.js";
import * as user from "./routes/user.js";
import * as pages from "./routes/pages.js";
import { createRequire } from "module"

const require = createRequire(import.meta.url);

require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
//const { Server } = require('ws');
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


//init är att skapa alla tables med dom kolumnerna som vi bestämt
//scaling (relational?) med MySQL eller i servern?


// Basic trial
app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});


//-------PAGES OF APP-------

//your own profile page, retrieves your user information and all of your products (aka. products with your user_id)
app.get('/profilepage/:user_id', (req, res) => pages.get_user_with_products(req, res, knex));






//-------PRODUCT-------

//test, get all info from product table
app.get('/helloworld', (req, res) => product.get_products(req, res, knex));

//Get a product of a certain product_id from product table
app.get('/product/get/:product_id', (req, res) => product.get_product(req, res, knex));

//Create a new product
app.post('/product/create', (req,res) => product.product_create(req, res, knex));

//Editing product
app.patch('/product/edit/:product_id', (req, res) => product.edit_product_all(req, res, knex));

//Deleting product
app.delete('/product/delete/:product_id', (req, res) => product.product_delete(req, res, knex));

//Retrieve the 5 most popular products
app.get('/product/top5popular', (req, res) => product.product_top5popular(req, res, knex));

//Retrieve the products in order of popularity
app.get('/product/popular', (req, res) => product.product_popular(req, res, knex));

//Updates number of bid by 1 for a certain product_id
app.patch('/product/updatebid/:product_id', (req, res) => product.product_bid(req, res, knex));


//------- USER -------

//Get all users in the database
app.get('/user/users', (req, res) => user.get_users(req, res, knex));

//Get a specific user from the user table
app.get('/user/:user_id', (req, res) => user.get_user(req, res, knex))

//Registering a new user
app.post('/user/registration', (req, res) => user.user_registration(req, res, knex));

//Adding a like (/thumbs up) to a user
app.patch('/user/like/:user_id', (req, res) => user.user_like(req, res, knex));

//Adding a dislike (/thumbs down) to a user
app.patch('/user/dislike/:user_id', (req, res) => user.user_dislike(req, res, knex));

//Deleting user
app.delete('/user/delete/:user_id', (req, res) => user.user_delete(req, res, knex));



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


/*
const server = express()
  .use((req, res) => res.send("Hejsan"))
  .listen(PORT, () => console.log('Listening on ${PORT}'));

const wss = new Server({ server });

wss.on('connection', function(ws, req) {
  ws.on('message', message => {
    var dataString = message.toString();
    console.log(dataString)
  })

  ws.on('message', message => {
    var dataString = message.toString();
    if (dataString == "Hello") {
        console.log(dataString)
        ws.send("Hi from Node.js");
    } else{
        console.log(dataString)
        ws.send("Are you not saying hi to me 🥺👉👈");
    }
}) 
})*/