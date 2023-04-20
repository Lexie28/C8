export { offer_create, offers_get }

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
  }
  