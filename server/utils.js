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

async function get_listings_for_user_and_offer(user_id, offer_id) {
    return db
	.from("listing")
	.innerJoin("offer_listing", "listing.id", "offer_listing.listing_id")
	.where({owner_id: user_id, offer_id: offer_id});
}

async function add_listing_objects_to_offer(offer) {
    offer.offered_items = [];
    offer.offered_items.push(await get_listings_for_user_and_offer(offer.user_making_offer, offer.id));

    offer.wanted_items = [];
    offer.wanted_items.push(await get_listings_for_user_and_offer(offer.user_receiving_offer, offer.id));
}

module.exports = { currentDateTime, newId, amountOfQueryStrings, entryExists, add_listing_objects_to_offer };
