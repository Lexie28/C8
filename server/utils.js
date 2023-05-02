const { v4: uuidv4 } = require('uuid');
const db = require("./db-config.js");

const currentDateTime = function() {
    return new Date().toISOString().slice(0, 19).replace('T', ' ');
}

const newId = function() {
    return uuidv4();
}

const amountOfQueryStrings = function(req) {
    return Object.keys(req.query).length;
}

const entryExists = async function(name, entry_id) {
    const entry = (await db(name).where({id: entry_id}))[0];    
    
    if (entry == undefined) {
	return false;
    }
    else{
	return true;
    }
}
module.exports = { currentDateTime, newId, amountOfQueryStrings, entryExists };
