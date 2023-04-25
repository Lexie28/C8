/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> } 
 */
exports.seed = async function(knex) {
    // Deletes ALL existing entries

  
  await knex("user").del()
  await knex("user").insert([
      {
	  id: "1",
	  name: "Elsa Larsson",
	  likes: 3205,
	  dislikes: 42,
	  profile_picture_path: null,
	  phone_number: "0701234567",
	  email: "elsa_larsson@protonmail.com"
      },
      
      {
	  id: "2",
	  name: "Lars Svensson",
	  likes: 2,
	  dislikes: 2,
	  profile_picture_path: null,
	  phone_number: "0709876543",
	  email: "lars_svensson@hotmail.com"
      }
  ]);
};

