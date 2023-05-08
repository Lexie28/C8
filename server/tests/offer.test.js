require('dotenv').config();

const request = require("supertest");
const app = require("../server.js");
const baseURL = app; //process.env.DATABASE_HOST + ":" + process.env.PORT;

describe("GET /offer", () => {
    var response;
    beforeAll( async () => {
	response = await request(baseURL).get("/offer");
    });
    it("Should return code 200", async () => {
	expect(response.statusCode).toBe(200);
	expect(response.error).toBe(false);
    });
    it("Should return at least one offer", async () => {
	expect(response._body.length >= 1).toBe(true);
    })
    it("Should return the listings related to the offer as a part of each object", () => {
	for(offer of response._body) {
	    expect(offer.wanted_items.length >= 1).toBe(true);
	    expect(offer.offered_items.length >= 1).toBe(true);
	}
	
    })

});


describe("GET /offer/:id", () => {
    var response;
    const id = "1";
    beforeAll( async () => {
	response = await request(baseURL).get("/offer/" + id);
    });
    it("Should return code 200", async () => {
	expect(response.statusCode).toBe(200);
	expect(response.error).toBe(false);
    });
    it("Should return one offer", async () => {
	expect(response._body.length == 1).toBe(true);
    })
    it("Should return user with correct id", async () => {
	const offer = response._body[0];
	expect(offer.id).toBe(id);
    });
    it("Should return 404 if offer with id doesn't exists", async () => {
	const nonexistant_response = await request(baseURL).get("/offer/this_id_doesnt_exist");
	expect(nonexistant_response.statusCode).toBe(404);
    })
    it("Should return the listings related to the offer as a part of the object", () => {
	expect(response._body[0].wanted_items.length >= 1).toBe(true);
	expect(response._body[0].offered_items.length >= 1).toBe(true);
    })

});

describe("POST /offer", () => {
    var response;

    const offered_listing_id = "1";
    const wanted_listing_id = "3";
    
    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [offered_listing_id, wanted_listing_id]
    }
    
    var offered_listing_number_of_bids_before_request;
    var wanted_listing_number_of_bids_before_request;
    beforeAll(async () => {
	offered_listing_number_of_bids_before_request = (await request(baseURL).get("/listing/" + offered_listing_id))._body.number_of_bids;	
	wanted_listing_number_of_bids_before_request = (await request(baseURL).get("/listing/" + wanted_listing_id))._body.number_of_bids;
    })
    
    it("Should return status code 201 when sent", async () => {
	response = await request(baseURL).post("/offer").send(offer);
	expect(response.statusCode).toBe(201);
    });
    
    it("Should return the generated id for the offer", async() => {
	const offer_creation_confirmation = response._body;
	const id_for_offer_created = offer_creation_confirmation.id;
	const offer_in_database = await request(baseURL).get("/offer/" + id_for_offer_created);
	expect(id_for_offer_created).toBe(offer_in_database._body[0].id);
    });
    
    it("Should increase the number of bids which a listing is involved with by 1", async () => {
	const offered_listing = (await request(baseURL).get("/listing/" + offered_listing_id))._body;
	const offered_listing_number_of_bids = offered_listing.number_of_bids;
	const wanted_listing = (await request(baseURL).get("/listing/" + wanted_listing_id))._body;
	const wanted_listing_number_of_bids = wanted_listing.number_of_bids;
	expect(offered_listing_number_of_bids).toBe(offered_listing_number_of_bids_before_request + 1);
	expect(wanted_listing_number_of_bids).toBe(wanted_listing_number_of_bids_before_request + 1);	
    })

    it("Should return status code 400 if one of the listings are unavailable", async () => {
	await request(baseURL).delete("/offer/" + response._body.id);
	
	const offered_listing_in_other_bid= "2";
	const wanted_listing_in_other_bid = "3";
	const offer = {
	    "user_making_offer": "1",
	    "user_receiving_offer" : "2",
	    "id_of_listings": [offered_listing_in_other_bid, wanted_listing_in_other_bid]
	}
	const other_bid_post_request = await request(baseURL).post("/offer").send(offer);
	await request(baseURL).patch("/offer/" + other_bid_post_request._body.id + "/accept");
	response = await request(baseURL).post("/offer").send(offer);
	expect(response.statusCode).toBe(400);
	
	await request(baseURL).delete("/offer/" + other_bid_post_request._body.id);
	
    });
    afterAll(async () => {
	await request(baseURL).delete("/offer/" + response._body.id);
    })
    
});

describe("PATCH /offer/:id/accept", () => {
    const offered_listing_id = "1";
    const wanted_listing_id = "3";
    
    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [offered_listing_id, wanted_listing_id]
    }

    var post_offer_request;
    var offer_id;
    beforeAll(async () => {
	post_offer_request = await request(baseURL).post("/offer").send(offer);
	offer_id = post_offer_request._body.id;	
    });



    var accept_response;
    it("Should get code 200 in response", async () => {
	accept_response = await request(baseURL).patch("/offer/" + offer_id + "/accept");
	expect(accept_response.statusCode).toBe(200);	
    });

    it("Should get 400 if tried again (both accept and reject)", async() => {
	const accept_again_response = await request(baseURL).patch("/offer/" + offer_id + "/accept");
	expect(accept_again_response.statusCode).toBe(400);
	
	const reject_response = await request(baseURL).patch("/offer/" + offer_id + "/accept");   
	expect(reject_response.statusCode).toBe(400);
    });
    it("Should make all listings involved unavailable", async () => {
	const offered_listing_after_accepted_bid = (await request(baseURL).get("/listing/" + offered_listing_id))._body;
	expect(offered_listing_after_accepted_bid.available).toBe(0);

	const wanted_listing_after_accepted_bid = (await request(baseURL).get("/listing/" + wanted_listing_id))._body;
	expect(wanted_listing_after_accepted_bid.available).toBe(0);
    })
    
    
    it("Should not be possible if the listings are no longer available", async () => {
	const offered_listing_in_other_bid= "2";
	const wanted_listing_in_other_bid = "3";
	const offer = {
	    "user_making_offer": "1",
	    "user_receiving_offer" : "2",
	    "id_of_listings": [offered_listing_in_other_bid, wanted_listing_in_other_bid]
	}
	const other_bid_post_request = await request(baseURL).post("/offer").send(offer);
	await request(baseURL).patch("/offer/" + other_bid_post_request._body.id + "/accept");
	
	response = await request(baseURL).patch("/offer/" + offer_id + "/accept").send(offer);
	expect(response.statusCode).toBe(400);
	
	await request(baseURL).delete("/offer/" + other_bid_post_request._body.id);
	
    })

    it("Should get status code 404 if offer doesn't exist", async () => {
	const accept_nonexisting_offer_response = await request(baseURL).patch("/offer/this_offer_id_is_completely_bogus/accept");
	expect(accept_nonexisting_offer_response.statusCode).toBe(404);
    })
    afterAll(async () => {
	await request(baseURL).delete("/offer/" + offer_id);
    })

    //TODO: gör test som visar att det inte går att acceptera ett offer där en listing inte är tillgänglig
});


describe("PATCH /offer/:id/reject", () => {
    const offered_listing_id = "1";
    const wanted_listing_id = "3";
    
    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [offered_listing_id, wanted_listing_id]
    }

    var post_offer_request;
    var offer_id;
    beforeAll(async () => {
	post_offer_request = await request(baseURL).post("/offer").send(offer);
	offer_id = post_offer_request._body.id;
    });

    var reject_response;
    it("Should get code 200 in response", async () => {
	reject_response = await request(baseURL).patch("/offer/" + offer_id + "/reject");
	expect(reject_response.statusCode).toBe(200);	
    });

    it("Should get 400 if tried again (both reject and reject)", async() => {
	const reject_again_response = await request(baseURL).patch("/offer/" + offer_id + "/reject");
	expect(reject_again_response.statusCode).toBe(400);
	
	const accept_response = await request(baseURL).patch("/offer/" + offer_id + "/accept");   
	expect(accept_response.statusCode).toBe(400);
    });

    it("Should get status code 404 if offer doesn't exist", async () => {
	const reject_nonexisting_offer_response = await request(baseURL).patch("/offer/this_offer_id_is_completely_bogus/reject");
	expect(reject_nonexisting_offer_response.statusCode).toBe(404);
    })
    afterAll(async () => {
	await request(baseURL).delete("/offer/" + offer_id);
    })

    it("Should not be able to reject an already accepted offer", async () => {
	const offered_listing_in_accepted_bid= "2";
	const wanted_listing_in_accepted_bid = "3";
	const offer = {
	    "user_making_offer": "1",
	    "user_receiving_offer" : "2",
	    "id_of_listings": [offered_listing_in_accepted_bid, wanted_listing_in_accepted_bid]
	}
	const create_offer_response =
	      await request(baseURL)
	      .post("/offer")
	      .send(offer);
	const accept_offer_response =
	      await request(baseURL)
	      .patch("/offer/" + create_offer_response._body.id+"/accept");
	
	const reject_accepted_offer_response =
	      await request(baseURL)
	      .patch("/offer/" + create_offer_response._body.id + "/reject");
	expect(reject_accepted_offer_response.statusCode).toBe(400);

	await await request(baseURL)
	    .delete("/offer/" + create_offer_response._body.id);
	
    })
});


describe("DELETE /offer/:id",  () => {
    const offered_listing_id = "1";
    const wanted_listing_id = "3";

    var offered_listing_bids_before_post;
    var wanted_listing_bids_before_post;

    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [offered_listing_id, wanted_listing_id]
    }

    var post_offer_request;
    var offer_id;
    beforeAll(async () => {
	offered_listing_bids_before_post =
	    (await request(baseURL).get("/listing/" + offered_listing_id))._body.number_of_bids;
	wanted_listing_bids_before_post =
	    (await request(baseURL).get("/listing/" + wanted_listing_id))._body.number_of_bids;
	
	post_offer_request = await request(baseURL).post("/offer").send(offer);
	offer_id = post_offer_request._body.id;
	

    });

    it("Should return code 200 when successful", async () => {
	const delete_offer_request = await request(baseURL).delete("/offer/" + offer_id);
	expect(delete_offer_request.statusCode).toBe(200);	
    })
    
    it("Should decrease the amount of bids for each listing", async () => {
	const offered_listing_get_request = await request(baseURL).get("/listing/" + offered_listing_id);
	expect(offered_listing_get_request._body.number_of_bids).toBe(offered_listing_bids_before_post);
	
	const wanted_listing_get_request = await request(baseURL).get("/listing/" + wanted_listing_id);
	expect(wanted_listing_get_request._body.number_of_bids).toBe(wanted_listing_bids_before_post)
    });
    
    it("Should remove the offer from the database", async() => {
	const get_delteted_user_request = await request(baseURL).get("/offer/" + offer_id);
	expect(get_delteted_user_request.statusCode).toBe(404);
    });
    it("Should return code 404 when trying to delete non-existing offer", async () => {
	const delete_non_existing_offer_request = await request(baseURL).delete("/offer/this_user_id_is_impossible");
	expect(delete_non_existing_offer_request.statusCode).toBe(404);
    });
})

