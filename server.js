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
    database : 'testar_c8'
  }
});


// Middleware
app.use(bodyParser.json());
app.use(cors());


const product = {
  product_name: "Banana",
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
const PORT = process.env.PORT || 3000;
/*app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});*/


const server = express()
  .use((req, res) => res.send("Hejsan"))
  .listen(PORT, () => console.log('Listening on ${PORT}'));

const wss = new Server({ server });

wss.on('connection', function(ws, req) {
  ws.on('message', message => {
    var dataString = message.toString();
    console.log(dataString)
  })
})