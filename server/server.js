import * as product from "./routes/product.js";
import * as user from "./routes/user.js";
import { createRequire } from "module"

const require = createRequire(import.meta.url);

require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const { Server } = require('ws');
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





//-------PRODUCT-------

//test, get all info from product table
app.get('/helloworld', (req, res) => product.get_product(req, res, knex));

//Create a new product
app.post('/product/create', (req,res) => product.create_product(req, res, knex));

//Editing product
app.patch('/product/edit/:product_id', (req, res) => product.edit_product_all(req, res, knex));

//Deleting product
app.delete('/product/delete/:product_id', (req, res) => product.delete_product(req, res, knex));




//------- USER -------

//Get all users in the database
app.get('/user/users', (req, res) => user.get_users(req, res, knex));

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

// Elsa har kommenterat ut detta för att det där nere ska funka, kan inte lyssna två ggr
/*app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});*/


var mes;

const server = express()
  .use((req, res) => res.send(mes.toString()))
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
        mes = message;
        console.log(dataString)
        ws.send("Are you not saying hi to me 🥺👉👈");
    }
}) 
})