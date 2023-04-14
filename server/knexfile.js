// Update with your config settings.
require('dotenv').config();
/**
 * @type { Object.<string, import("knex").Knex.Config> }
 */
module.exports = {
  development: {
    client: 'mysql2',
    connection: {
	database: process.env.DATABASE_NAME,
	user:     process.env.USER_NAME,
	password: process.env.USER_PASSWORD
    },
    migrations: {
	directory: "./migrations"
    }
  }

};
