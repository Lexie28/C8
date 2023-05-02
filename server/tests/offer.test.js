require('dotenv').config();

const request = require("supertest");
const baseURL = process.env.DATABASE_HOST + ":" + process.env.PORT;

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
    
});

describe("POST /offer", () => {
    var response;

    const listing_1_id = "1";
    const listing_2_id = "2";
    
    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [listing_1_id, listing_2_id]
    }
    
    var listing_1_amount_of_bids_before_request;
    var listing_2_amount_of_bids_before_request;
    beforeAll(async () => {
	listing_1_amount_of_bids_before_request = (await request(baseURL).get("/listing/" + listing_1_id))._body.amount_of_bids;
	listing_2_amount_of_bids_before_request = (await request(baseURL).get("/listing/" + listing_2_id))._body.amount_of_bids;
    })
    
    it("Should return status code 200 when sent", async () => {
	response = await request(baseURL).post("/offer").send(offer);
	expect(response.statusCode).toBe(200);
    });
    
    it("Should return the generated id for the offer", async() => {
	const offer_creation_confirmation = response._body;
	const id_for_offer_created = offer_creation_confirmation.id;
	const offer_in_database = await request(baseURL).get("/offer/" + id_for_offer_created);
	expect(id_for_offer_created).toBe(offer_in_database._body[0].id);
    });
    
    it("Should increase the number of bids which a listing is involved with by 1", async () => {
	const listing_1 = (await request(baseURL).get("/listing/" + listing_1_id))._body;
	const listing_1_amount_of_bids = listing_1.amount_of_bids;
	const listing_2 = (await request(baseURL).get("/listing/" + listing_2_id))._body;
	const listing_2_amount_of_bids = listing_2.amount_of_bids;
	expect(listing_1_amount_of_bids).toBe(listing_1_amount_of_bids_before_request);
	expect(listing_2_amount_of_bids).toBe(listing_2_amount_of_bids_before_request);	
    })

    afterAll(async () => {
	request(baseURL).delete("/offer/" + response._body.id);
    })
    
});

describe("PATCH /offer/:id/accept", () => {
    const listing_1_id = "1";
    const listing_2_id = "2";
    
    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [listing_1_id, listing_2_id]
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

    //TODO: gör ett test för att se att alla listings har blivit unavailable
    afterAll(async () => {
	await request(baseURL).delete("/offer/" + offer_id);
    })
});


//TODO: skriva om copy-pastead del så att den är för reject
/*
describe("PATCH /offer/:id/reject", () => {
    const listing_1_id = "1";
    const listing_2_id = "2";
    
    const offer = {
	"user_making_offer": "1",
	"user_receiving_offer" : "2",
	"id_of_listings": [listing_1_id, listing_2_id]
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
	
	const reject_response = await request(baseURL).patch("/offer/" + offer_id + "/reject");   
	expect(reject_response.statusCode).toBe(400);
    });

    afterAll(async () => {
	await request(baseURL).delete("/offer/" + offer_id);
    })
});
*/
//TODO: gör tester för delete
/*describe("DELETE /offer/:id", async () => {
    
}*/
