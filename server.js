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


const product = {
  product_name: "Banana",
  product_desc: "God",
  product_price: 100
}

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
})
