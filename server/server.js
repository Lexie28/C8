listing = require("./routes/listing.js");
user = require( "./routes/user.js");
pages = require( "./routes/pages.js");
offer = require( "./routes/offer.js");

require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
//const { Server } = require('ws');
const cors = require('cors');
const app = express();
//const db = require("db-config.js");

// Middleware
app.use(bodyParser.json());
app.use(cors());


//Routers
app.use(listing);
app.use( user);
app.use( pages);
app.use( offer);

const swaggerUi = require('swagger-ui-express');
const swaggerFile = require('./swagger_output.json');
app.use('/doc', swaggerUi.serve, swaggerUi.setup(swaggerFile));
//init är att skapa alla tables med dom kolumnerna som vi bestämt
//scaling (relational?) med MySQL eller i servern?


// Basic trial
app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});


//-------PAGES OF APP-------



//-------USER-------



app.post('/user/exists/:user_id', (req, res) => user.user_exists(req, res, knex));



//-------OFFER-------



app.get('/offer/get/:bid_id', (req, res) => offer.get_bid_info(req, res, knex));











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
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});



