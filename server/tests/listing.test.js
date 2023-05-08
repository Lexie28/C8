//require('dotenv').config();

const request = require("supertest");
const app = require("../server.js");
const baseURL = app; //process.env.DATABASE_HOST + ":" + process.env.PORT;

describe("GET /listing", () => {
    var get_listing_response;
    beforeAll(async () => {
	get_listing_response = await request(baseURL).get("/listing");
    });

    it("Should return code 200", async () => {
	expect(get_listing_response.statusCode).toBe(200);
	expect(get_listing_response.error).toBe(false);
    });
    it("Should return at least one offer", async () => {
	expect(get_listing_response._body.length >= 1).toBe(true);
    })

    it("Should exclude user passed as parameter", async () => {
	const id_of_excluded_user = "1";
	const exclude_user_response =
	      await request(baseURL)
	      .get("/user?exclude_user="+ id_of_excluded_user);
	
	for(listing of exclude_user_response._body) {
	    expect(listing.owner_id !== id_of_excluded_user);
	}
    });

    it("Should sort in a correct way given a value for query string popularity", async () => {
	const popular_sort_response =
	      await request(baseURL)
	      .get("/user?sort=popular");
	const listings = popular_sort_response._body;
	
	var previous_listings_amount_of_bids = listings[0];
	for(listing of listings) {
	    expect(previous_listings_amount_of_bids >= listing.amount_of_bids);
	    previous_listings_amount_of_bids = listing.amount_of_bids;
	}
    })

    it("Should return what is expected from ceirtan values of query amount", async () => {
	const one_listing_response =
	      await request(baseURL)
	      .get("/listing?amount=1");

	expect(one_listing_response._body.length).toBe(1);


	const three_listings_response =
	      await request(baseURL)
	      .get("/listing?amount=3");

	expect(three_listings_response._body.length).toBe(3);

	const non_integer_amount_response =
	      await request(baseURL)
	      .get("/listing?amount=lololol");

	expect(non_integer_amount_response.statusCode).toBe(400);

	const negative_number_amount_response =
	      await request(baseURL)
	      .get("/listing?amount=-1");

	expect(negative_number_amount_response.statusCode).toBe(400);
    });
    
})


describe("GET /listing/:id", () => {
    var get_listing_response;
    const id = "1";
    beforeAll( async () => {
	get_listing_response = await request(baseURL).get("/offer/" + id);
    });
    it("Should return code 200", async () => {
	expect(get_listing_response.statusCode).toBe(200);
	expect(get_listing_response.error).toBe(false);
    });
    it("Should return one listing", async () => {
	expect(get_listing_response._body.length == 1).toBe(true);
    })
    it("Should return listing with correct id", async () => {
	const listing = get_listing_response._body[0];
	expect(listing.id).toBe(id);
    });
    it("Should return 404 if offer with id doesn't exists", async () => {
	const get_nonexistant_listing_response =
	      await request(baseURL)
	      .get("/offer/this_id_doesnt_exist");
	
	expect(get_nonexistant_listing_response.statusCode).toBe(404);
    })
    
});


describe("POST /listing", () => {
    var post_listing_response;
    const listing = {
	"name": "Tomato",
	"description": "Very yummy!",
	"category": "Food",
	"image_path": "tomato.png",
	"owner_id": "1"
    }
    beforeAll(async () => {
	post_listing_response =
	    await request(baseURL)
	    .post("/listing").send(listing);
    })

    it("Should return code 201", async () => {
	expect(post_listing_response.statusCode).toBe(201);
    })

    it("Should create a listing with returned id", async () => {
	const get_listing_with_id_from_post_request =
	      await request(baseURL)
	      .get("/listing/" + post_listing_response._body.id);
	expect(get_listing_with_id_from_post_request.statusCode).toBe(200);
    })

    afterAll(async () => {
	await request(baseURL)
	    .delete("/listing/" + post_listing_response._body.id);
    })
})

describe("DELETE /listing/:id", () => {
    var post_listing_response;
    var delete_listing_response;
    const listing = {
	"name": "Tomato",
	"description": "Very yummy!",
	"category": "Food",
	"image_path": "tomato.png",
	"owner_id": "1"
    }
    beforeAll(async () => {
	post_listing_response =
	    await request(baseURL)
	    .post("/listing").send(listing);

	delete_listing_response =
	    await request(baseURL)
	    .delete("/listing/" + post_listing_response._body.id);
    })

    it("Should return status code 200", async () => {
	expect(delete_listing_response.statusCode).toBe(200);
    })
    
    it("Should remove the listing from the database", async () => {
	const get_deleted_listing_response =
	    await request(baseURL)
	    .get("/listing/" + post_listing_response._body.id);
	expect(get_deleted_listing_response.statusCode).toBe(404);
	    
    })

    it("Should return status code 404 if listing doesn't exist", async () => {
	const delete_non_existing_listing_response =
	      await request(baseURL)
	      .delete("/listing/this_listing_id_will_never_exist");

	expect(delete_non_existing_listing_response.statusCode).toBe(404);
    })
})


describe("PATCH /listing", () => {
    var post_listing_response;
    var patch_listing_response;
    const listing = {
	"name": "Tomatoe",
	"description": "Vry ym!1",
	"category": "Fod",
	"image_path": "tomato1.png",
	"owner_id": "1"
    }
    
    const listing_patch = {
	"name": "Tomato",
	"description": "Very yummy!",
	"category": "Food",
	"image_path": "tomato2.png"
    }
    
    beforeAll(async () => {
	post_listing_response =
	    await request(baseURL)
	    .post("/listing").send(listing);

	patch_listing_response =
	    await request(baseURL)
	    .patch("/listing/" + post_listing_response._body.id)
	    .send(listing_patch);
    })

    it("Should return status code 200", async () => {
	expect(patch_listing_response.statusCode).toBe(200);
    })

    it("Should have changed the values of the entry in the database", async () => {
	const get_patched_listing_response =
	      await request(baseURL)
	      .get("/listing/" + post_listing_response._body.id);
	expect(get_patched_listing_response._body.name).toBe(listing_patch.name);	
    })

    it("Should return status code 404 if no listing with id exists", async () => {
	const patch_non_existing_listing_response =
	      await request(baseURL)
	      .patch("/listing/alert_bogus_listing_id");

	expect(patch_non_existing_listing_response.statusCode).toBe(404);
    })
})


