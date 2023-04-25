const knex = require("knex");

const config = require("./knexfile.js");

const db = knex(config.development);

module.exports = db;

//https://dev.to/cesareferrari/configuring-knex-in-an-express-application-335b
