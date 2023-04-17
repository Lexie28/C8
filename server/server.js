import * as listing from "./routes/listing.js";
import * as user from "./routes/user.js";
import * as pages from "./routes/pages.js";
import { createRequire } from "module";

//const require = createRequire(import.meta.url);

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
    user: process.env.USER_NAME,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME
  }
});


app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});

const tables = ["user", "listing", "offer"];

function getTableNameFromUrl(url) {
    const url_splitted = url.split('/');

    return url_splitted[1];
}

    
for(table of tables) {
    console.log(table);
    app.get("/" + table, (req, res) => {
	var table_name = getTableNameFromUrl(req.url);
	
	knex.select("*")
	    .from(table_name)
	    .then((result) => {
		res.send(result);
	    })
	    .catch((err) => {
		console.log(err);
		res.status(500).json({message: "error!"});
	    })
    })

    app.get("/" + table + "/:id", (req, res) => {
	const id = req.params.id;
	var table_name = getTableNameFromUrl(req.url);
	
	knex.select("*")
	    .from(table_name)
	    .where(table_name + ".id", "=", id)
	    .then((result) => {
		res.send(result);
	    })
	    .catch((err) => {
		console.log(err)
		res.status(500).json({message: "error!"});
	    })
    });

    app.post("/" + table, (req, res) => {
	var table_name = getTableNameFromUrl(req.url);
	knex.insert(req.body)
	    .then((result) => {
		res.status(200).json({message: table_name + " created"});		    
	    })
	    .catch((err) => {
		console.log(err)
		res.status(500).json({message: "error!"});
	    })
    });

    app.delete("/" + table + "/:id", (req, res) => {
	const id = req.params.id;
	var table_name = getTableNameFromUrl(req.url);
	knex.select("*")
	    .from(table_name)
	    .where(table_name + ".id", "=", id)
	    .del()
	    .then(result => {
		res.status(200).json({message: table_name + " with id " + id + " deleted!"})
	    })
	    .catch((err) => {
		console.log(err)
		res.status(500).json({message: "error!"});
	    })
    });
    
    
}

    


// Middleware
app.use(bodyParser.json());
app.use(cors());

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

/* --------------------------------------------------
   GAMLA OCH ICKE-CRAZY (dvs sunda) GREJER
   --------------------------------------------------
//init är att skapa alla tables med dom kolumnerna som vi bestämt
//scaling (relational?) med MySQL eller i servern?
// Basic trial
app.get('/', (req, res) => {
  res.send('Welcome to Circle Eight!');
});


//-------PAGES OF APP-------

//your own profile page, retrieves your user information and all of your listings (aka. listings with your user_id)
app.get('/profilepage/:user_id', (req, res) => pages.get_user_with_listings(req, res, knex));



//-------LISTING-------

//test, get all info from listing table
app.get('/listings/', (req, res) => listing.get_listings(req, res, knex));

//Get a listing of a certain listing_id from listing table
app.get('/listing/get/:listing_id', (req, res) => listing.get_listing(req, res, knex));

//Create a new listing
app.post('/listing/create', (req,res) => listing.listing_create(req, res, knex));

//Editing listing
app.patch('/listing/edit/:listing_id', (req, res) => listing.edit_listing_all(req, res, knex));

//Deleting listing
app.delete('/listing/delete/:listing_id', (req, res) => listing.listing_delete(req, res, knex));

//Retrieve the 5 most popular listings
app.get('/listing/top5popular', (req, res) => listing.listing_top5popular(req, res, knex));

//Retrieve the listings in order of popularity based on number of bids
app.get('/listing/popular', (req, res) => listing.listing_popular(req, res, knex));

//Updates number of bid by 1 for a certain listing_id
app.patch('/listing/updatebid/:listing_id', (req, res) => listing.listing_bid(req, res, knex));

//Retrieves all items of a certain category
app.get('/listing/category/:listing_category', (req, res) => listing.listing_category(req, res, knex));




//-------USER-------

//Get all users in the database
app.get('/user/users', (req, res) => user.get_users(req, res, knex));

//Get a specific user from the user table
app.get('/user/get/:user_id', (req, res) => user.get_user(req, res, knex))

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

var mes;

/*
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
})*/

