export { offer_create, offers_get, get_bid_info }

function offer_create(req, res, knex) {
    const { bid_maker_id, bid_receiver_id, bid_active, listing_ids } = req.body;
  
    knex.transaction(function(trx) {
      return trx.insert({
          bid_maker_id: bid_maker_id,
          bid_receiver_id: bid_receiver_id,
          bid_active: bid_active
        })
        .into('offer')
        .returning('bid_id')
        .then(function(bid_id) {
          var offerListings = [];
          for (var i = 0; i < listing_ids.length; i++) {
            offerListings.push({
              bid_id: bid_id[0],
              listing_id: listing_ids[i]
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


  function offers_get(req, res, knex) {
    const { user_id } = req.params;
  
    knex.select('offer.bid_id', 'offer.bid_maker_id', 'offer.bid_receiver_id')
      .from('offer')
      .where('offer.bid_maker_id', user_id)
      .orWhere('offer.bid_receiver_id', user_id)
      .then(function(offers) {
        const promises = offers.map(function(offer) {
          return knex.select('offer_listing.listing_id', 'offer_listing.bid_id','listing.listing_name', 'listing.listing_description', 'user.user_id', 'user.user_name')
            .from('offer_listing')
            .innerJoin('listing', 'listing.listing_id', 'offer_listing.listing_id')
            .innerJoin('user', 'user.user_id', 'listing.user_id')
            .where('offer_listing.bid_id', offer.bid_id)
            .then(function(listings) {
              const bidMaker = listings.find(function(listing) { return listing.user_id === offer.bid_maker_id; });
              const bidReceiver = listings.find(function(listing) { return listing.user_id === offer.bid_receiver_id; });
              const bidListings = {
                bid_id: offer.bid_id,
                bid_maker: {
                  user_id: bidMaker.user_id,
                  user_name: bidMaker.user_name,
                  listings: []
                },
                bid_receiver: {
                  user_id: bidReceiver.user_id,
                  user_name: bidReceiver.user_name,
                  listings: []
                }
              };
              listings.forEach(function(listing) {
                if (listing.user_id === offer.bid_maker_id) {
                  bidListings.bid_maker.listings.push({
                    listing_id: listing.listing_id,
                    listing_name: listing.listing_name,
                    listing_description: listing.listing_description
                  });
                } else if (listing.user_id === offer.bid_receiver_id) {
                  bidListings.bid_receiver.listings.push({
                    listing_id: listing.listing_id,
                    listing_name: listing.listing_name,
                    listing_description: listing.listing_description
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
  function offers_get(req, res, knex) {
    const { user_id } = req.params;
  
    knex.select('offer.bid_id', 'offer.bid_maker_id', 'offer.bid_receiver_id')
      .from('offer')
      .where('offer.bid_maker_id', user_id)
      .orWhere('offer.bid_receiver_id', user_id)
      .then(function(offers) {
        const promises = offers.map(function(offer) {
          return knex.select('offer_listing.listing_id', 'offer_listing.bid_id','listing.listing_name', 'listing.listing_description', 'user.user_id', 'user.user_name')
            .from('offer_listing')
            .innerJoin('listing', 'listing.listing_id', 'offer_listing.listing_id')
            .innerJoin('user', 'user.user_id', 'listing.user_id')
            .where('offer_listing.bid_id', offer.bid_id)
            .then(function(listings) {
              const bidMaker = listings.find(function(listing) { return listing.user_id === offer.bid_maker_id; });
              const bidReceiver = listings.find(function(listing) { return listing.user_id === offer.bid_receiver_id; });
              const bidListings = {
                bid_maker: {
                  user_id: bidMaker.user_id,
                  user_name: bidMaker.user_name,
                  listings: []
                },
                bid_receiver: {
                  user_id: bidReceiver.user_id,
                  user_name: bidReceiver.user_name,
                  listings: []
                }
              };
              listings.forEach(function(listing) {
                if (listing.user_id === offer.bid_maker_id) {
                  bidListings.bid_maker.listings.push({
                    listing_id: listing.listing_id,
                    listing_name: listing.listing_name,
                    listing_description: listing.listing_description
                  });
                } else if (listing.user_id === offer.bid_receiver_id) {
                  bidListings.bid_receiver.listings.push({
                    listing_id: listing.listing_id,
                    listing_name: listing.listing_name,
                    listing_description: listing.listing_description
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
  }*/

  function get_bid_info(req, res, knex) {
    const { bid_id } = req.params;
  
    knex.select('offer.bid_id', 'offer.bid_maker_id', 'offer.bid_receiver_id')
      .from('offer')
      .where('offer.bid_id', bid_id)
      .then(function(offer) {
        return knex.select('offer_listing.listing_id', 'listing.listing_name', 'listing.listing_description', 'user.user_id', 'user.user_name', 'user.user_location', 'user.user_num_likes', 'user.user_num_dislikes')
          .from('offer_listing')
          .innerJoin('listing', 'listing.listing_id', 'offer_listing.listing_id')
          .innerJoin('user', 'user.user_id', 'listing.user_id')
          .where('offer_listing.bid_id', bid_id)
          .then(function(listings) {
            const bidMaker = listings.find(function(listing) { return listing.user_id === offer[0].bid_maker_id; });
            const bidReceiver = listings.find(function(listing) { return listing.user_id === offer[0].bid_receiver_id; });
            const bidInfo = {
              bid_id: offer[0].bid_id,
              bid_maker: {
                user_id: bidMaker.user_id,
                user_name: bidMaker.user_name,
                user_location: bidMaker.user_location,
                user_num_likes: bidMaker.user_num_likes,
                user_num_dislikes: bidMaker.user_num_dislikes,
                listings: []
              },
              bid_receiver: {
                user_id: bidReceiver.user_id,
                user_name: bidReceiver.user_name,
                user_location: bidReceiver.user_location,
                user_num_likes: bidReceiver.user_num_likes,
                user_num_dislikes: bidReceiver.user_num_dislikes,
                listings: []
              }
            };
            listings.forEach(function(listing) {
              if (listing.user_id === offer[0].bid_maker_id) {
                bidInfo.bid_maker.listings.push({
                  listing_id: listing.listing_id,
                  listing_name: listing.listing_name,
                  listing_description: listing.listing_description
                });
              } else if (listing.user_id === offer[0].bid_receiver_id) {
                bidInfo.bid_receiver.listings.push({
                  listing_id: listing.listing_id,
                  listing_name: listing.listing_name,
                  listing_description: listing.listing_description
                });
              }
            });
            return bidInfo;
          });
      })
      .then(function(bidInfo) {
        res.status(200).json(bidInfo);
      })
      .catch(function(err) {
        console.log(err);
        res.status(500).json({ message: 'An error occurred while retrieving bid information' });
      });
  }
  
    
  

  /*
  function offers_get(req, res, knex) {
    const user_id = req.params.user_id;
  
    knex.select("offer.bid_id", "listing.listing_id", "listing.listing_name", "listing.listing_description", "listing.user_id as listing_user_id", "listing.listing_category", "user.user_id as other_user_id", "user.user_name", "user.user_location")
      .from("offer")
      .leftJoin("offer_listing", "offer.bid_id", "offer_listing.bid_id")
      .leftJoin("listing", "offer_listing.listing_id", "listing.listing_id")
      .leftJoin("user", function() {
        this.on("user.user_id", "=", "offer.bid_maker_id").orOn("user.user_id", "=", "offer.bid_receiver_id")
      })
      .where("offer.bid_maker_id", user_id)
      .orWhere("offer.bid_receiver_id", user_id)
      .then((result) => {
        const offers = {};
        for (const row of result) {
          if (!offers[row.bid_id]) {
            offers[row.bid_id] = {
              bid_id: row.bid_id,
              listings: []
            };
          }
          const listing = {
            listing_id: row.listing_id,
            listing_name: row.listing_name,
            listing_description: row.listing_description,
            listing_category: row.listing_category,
            user_id: row.listing_user_id
          };
          const other_user_id = row.other_user_id !== user_id ? row.other_user_id : null;
          const other_user = {
            user_id: other_user_id,
            user_name: row.user_name,
            user_location: row.user_location
          };
          offers[row.bid_id].listings.push({listing, other_user});
        }
        res.json(Object.values(offers));
      })
      .catch((error) => {
        console.error(error);
        res.status(500).json({message: "Internal server error"});
      });
  }*/