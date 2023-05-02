const express = require("express");
const router = express.Router();
const {currentDateTime, newId, entryExists} = require("../utils.js");

const db = require("../db-config.js");


async function offer_create(req, res) {

    //TODO: Se till att offern har items från två olika användare med listings som är available
    const { user_making_offer, user_receiving_offer, id_of_listings} = req.body;

    const offerId = newId();
    db.transaction(function(trx) {

	return trx.insert({
	    id: offerId,
            user_making_offer: user_making_offer,
            user_receiving_offer: user_receiving_offer,
	    creation_date: currentDateTime()
        })
            .into('offer')
            .returning('id')
            .then(async function(result) {
		console.log(result);
		var offerListings = [];
		for (var i = 0; i < id_of_listings.length; i++) {
		    await db("listing")
			.where("id", id_of_listings[i])
			.increment("number_of_bids", 1);
		    
		    offerListings.push({
			offer_id: offerId,
			listing_id: id_of_listings[i]
		    });
		}
		return trx.insert(offerListings).into('offer_listing');
            });
    })
	.then(function() {
	    res.status(200).json({ message: 'Trade offer created successfully' , id: offerId});
	})
	.catch(function(err) {
	    console.log(err);
	    res.status(500).json({ message: 'An error occurred while creating the trade offer' });
	});
};


function offers_get(req, res) {
    const { id } = req.params;
    
    db.select('offer.id', 'offer.user_making_offer', 'offer.user_receiving_offer')
	.from('offer')
	.where('offer.user_making_offer', id)
	.orWhere('offer.user_receiving_offer', id)
	.then(function(offers) {
            const promises = offers.map(function(offer) {
		return db.select('offer_listing.id', 'listing.name', 'listing.description', 'user.id', 'user.name')
		    .from('offer_listing')
		    .innerJoin('listing', 'listing.id', 'offer_listing.id')
		    .innerJoin('user', 'user.id', 'listing.id')
		    .where('offer_listing.id', offer.id)
		    .then(function(listings) {
			const bidMaker = listings.find(function(listing) { return listing.id === offer.user_making_offer; });
			const bidReceiver = listings.find(function(listing) { return listing.id === offer.user_receiving_offer; });
			const bidListings = {
			    bid_maker: {
				id: bidMaker.id,
				name: bidMaker.name,
				listings: []
			    },
			    bid_receiver: {
				id: bidReceiver.id,
				name: bidReceiver.name,
				listings: []
			    }
			};
			listings.forEach(function(listing) {
			    if (listing.id === offer.user_making_offer) {
				bidListings.bid_maker.listings.push({
				    id: listing.id,
				    name: listing.name,
				    description: listing.description
				});
			    } else if (listing.id === offer.user_receiving_offer) {
				bidListings.bid_receiver.listings.push({
				    id: listing.id,
				    name: listing.name,
				    description: listing.description
				});
			    }
			});
			return bidListings;
		    });
            });
	    
            Promise.all(promises)
		.then(function(results) {
		    res.status(200).json(results);
		})
		.catch(function(err) {
		    console.log(err);
		    res.status(500).json({ message: 'An error occurred while retrieving trade offers' });
		});
	});
}



/*
  function offers_get(req, res) {
  const id = req.params.id;
  
  db.select("offer.id", "listing.id", "listing.name", "listing.description", "listing.id as id", "listing.listing_category", "user.id as other_id", "user.name", "user.user_location")
  .from("offer")
  .leftJoin("offer_listing", "offer.id", "offer_listing.id")
  .leftJoin("listing", "offer_listing.id", "listing.id")
  .leftJoin("user", function() {
  this.on("user.id", "=", "offer.user_making_offer").orOn("user.id", "=", "offer.user_receiving_offer")
  })
  .where("offer.user_making_offer", id)
  .orWhere("offer.user_receiving_offer", id)
  .then((result) => {
  const offers = {};
  for (const row of result) {
  if (!offers[row.id]) {
  offers[row.id] = {
  id: row.id,
  listings: []
  };
  }
  const listing = {
  id: row.id,
  name: row.name,
  description: row.description,
  listing_category: row.listing_category,
  id: row.id
  };
  const other_id = row.other_id !== id ? row.other_id : null;
  const other_user = {
  id: other_id,
  name: row.name,
  user_location: row.user_location
  };
  offers[row.id].listings.push({listing, other_user});
  }
  res.json(Object.values(offers));
  })
  .catch((error) => {
  console.error(error);
  res.status(500).json({message: "Internal server error"});
  });
  }*/

router.get("/offer", (req, res) => {
    db("offer").select("*").then((result) => {
	res.send(result);
    })
})

router.post('/offer', (req, res) => offer_create(req, res));

router.get('/offer/:id', (req, res) => {
    const { id } = req.params;
    
    db("offer")
	.select("*")
	.where({id: id})
	.then((result) => {
	    if(result.length == 0) {
		res.status(404).json({message: "Offer with id not found"});
		return;
	    }
	    else {
		res.status(200).json(result);
	    }
	})

});
	  
router.patch("/offer/:id/accept", async (req, res) => {
    const offer_id = req.params.id;

    if(!(await entryExists("offer", offer_id))) {
	res.status(404).json({message: "Offer doesn't exist!"});
	return;
    }
    
    const offer = (await db("offer").where({id: offer_id}))[0];
    
    if (offer.accepted == 1) {
	res.status(400).json({message: "Offer is already accepted"});
	return;
    }

    else if (offer.rejected == 1) {
	res.status(400).json({message: "Offer has already been rejected. Cannot be accepted!"});
	return;
    }
    
    db("offer")
	.where({id: offer_id})
	.update({accepted: 1})
	.then(async (result) => {
	    //SQL query: update listing set available=0 where id in (select listing_id from offer_listing where offer_id = 1);
	    //TODO: Fixa logiken för om någon listing ej är available
	    await db('listing')
		.whereIn('id', function() {
		    this.select('listing_id')
			.from('offer_listing')
			.where('offer_id', offer_id);
		})
		.update({available:0});

	    res.status(200).json({message: "Offer accepted!"});
	    return;
	})
	.catch((err) => {
	    res.status(500).json({message: "Error! " + err});
	    return;
	});
})

router.patch("/offer/:id/reject", async (req, res) => {
    const offer_id = req.params.id;

    if(!(await entryExists("offer", offer_id))) {
	res.status(404).json({message: "Offer doesn't exist!"});
	return;
    }
    
    const offer = (await db("offer").where({id: offer_id}))[0];
    
    if (offer.rejected == 1) {
	res.status(400).json({message: "Offer is already rejected"});
	return;
    }
    else if (offer.accepted == 1) {
	res.status(400).json({message: "Offer has already been accepted. Cannot be rejected!"});
	return;
    }
    
    db("offer")
	.where({id: offer_id})
	.update({rejected: 1})
	.then((result) => {
	    res.status(200).json({message: "Offer successfully rejected!"});
	})
	.catch((err) => {
	    res.status(500).json({message: "Error! " + err});
	});
    
    
})

router.delete("/offer/:id",async (req, res) => {
    //TODO: gör så att number of bids för listings minskar när offer tas bort
    const offer_id = req.params.id;
    
    if(!(await entryExists("offer", offer_id))) {
	res.status(404).json({message: "Offer doesn't exist!"});
	return;
    }
    db("offer")
	.where({id:offer_id})
	.del()
	.then((result) => {
	    res.status(200).json({message: "Offer successfully deleted!"});
	})
	.catch((err) => {
	    res.status(500).json({message: "Error! " + err});
	})
	      	      	      
})
module.exports = router;
