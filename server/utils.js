const { v4: uuidv4 } = require('uuid');

const currentDateTime = function() {
    return new Date().toISOString().slice(0, 19).replace('T', ' ');
}

const newId = function() {
    return uuidv4();
}

const amountOfQueryStrings = function(req) {
    return Object.keys(req.query).length;
}
module.exports = { currentDateTime, newId, amountOfQueryStrings };
