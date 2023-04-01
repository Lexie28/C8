//import * as routes from C8/routes/user.js;

require('dotenv').config()
const express = require('express');
const { Server } = require('ws');
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


//-------PRODUCT-------


app.get('/helloworld', (req, res) => {
  knex.select("*").from("product").then((result) => {
    res.send(result)
  })
});


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


//Adding a like (/thumbs up) to a user
app.patch('/user/like/:user_id', (req, res) => {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
    .increment('num_likes', 1) // use the `increment` method to add 1 to `num_likes`
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


//Adding a dislike (/thumbs down) to a user
app.patch('/user/dislike/:user_id', (req, res) => {
  const { user_id } = req.params;

  knex('user')
    .where({ user_id })
    .increment('num_dislikes', 1) // use the `increment` method to add 1 to `num_likes`
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

const server = express()
    .use((req, res) => res.send("Hi there"))
    .listen(PORT, () => console.log(`Listening on ${PORT}`));

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
})