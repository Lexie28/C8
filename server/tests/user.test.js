require('dotenv').config();

const request = require("supertest");
const baseURL = process.env.DATABASE_HOST + ":" + process.env.PORT;

const initial_response = request(baseURL).get("/user");
const amount_of_users = initial_response.body
//TODO: dela upp i flera unit tests.
describe("GET /user", () => {
    it("Should return 200", async () => {
	const response = await request(baseURL).get("/user");
	expect(response.statusCode).toBe(200);
	expect(response.error).toBe(false);
    });
    it("Should return users", async () => {
	const response = await request(baseURL).get("/user");
	expect(response._body.length == 2).toBe(true);
    });
});

describe("POST /user", () => {
    afterAll(async () => {
	await request(baseURL).delete(`${}`); //TODO: skriv klart
    }
}
describe("PATCH /user/:id/like, PATCH /user/:id/dislike, and GET /user/:id", () => {
    const newUser = {
	"id": 999999,
	"name": "John Doe",
	"profile_picture_path": "~/pictures/profile_picture_1.jpg",
	"phone_number": "0701234567",
	"email": "john_doe@protonmail.com",
	"location": "Uppsala"
    }

    beforeAll(async () => {
	await request(baseURL).post("/user").send(newUser);
    });
    afterAll(async () => {
	await request(baseURL).delete(`/user/${newUser.id}`);
    })
    
    it("Should successfully like user", async () => {
	const response = await request(baseURL).patch(`/user/${newUser.id}/like`);
	expect(response.statusCode).toBe(200);
	expect(response.error).toBe(false);
    });

    it("Should successfully dislike user", async () => {
	const response = await request(baseURL).patch(`/user/${newUser.id}/dislike`);
	expect(response.statusCode).toBe(200);
	expect(response.error).toBe(false);
    });
       
    it("Should return 200", async () => {
	const response = await request(baseURL).get(`/user/${newUser.id}`);	
	expect(response.statusCode).toBe(200);
	expect(response.error).toBe(false);
    });
       
    it("Should return the user with correct amount of likes and dislikes", async () => {
	const response = await request(baseURL).get(`/user/${newUser.id}`);
	const user = response._data[0];
	expect(user.id).toBe(newUser.id);
    });
});
	       
