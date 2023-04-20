const express = require("express");
const router = express.Router();

const db = require("../db-config.js");


function offer_create(req, res) {
    const { user_making_offer, user_receiving_offer, accepted, ids } = req.body;
  
    db.transaction(function(trx) {
      return trx.insert({
          user_making_offer: user_making_offer,
          user_receiving_offer: user_receiving_offer,
          accepted: accepted
        })
        .into('offer')
        .returning('id')
        .then(function(id) {
          var offerListings = [];
          for (var i = 0; i < ids.length; i++) {
            offerListings.push({
              id: id[0],
              id: ids[i]
            });
          }
          return trx.insert(offerListings).into('offer_listing');
        });
    })
    .then(function() {
      res.status(200).json({ message: 'Trade offer created successfully' });
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
//Creates a new offer
router.post('/offer', (req, res) => offer_create(req, res));

//Lists all of the offers your id is involved in
//TODO: flytta till user controller
router.get('/offer/offers/:id', (req, res) => offers_get(req, res));


module.exports = router;
