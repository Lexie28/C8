/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> } 
 */
exports.seed = async function(knex) {
  // Deletes ALL existing entries
  await knex('listing').del()
    await knex('listing').insert([

	//--------------------ELSAS LISTINGS--------------------
      {
	  id: "1",
	  name: "Red apple",
	  description: "Nice apple. Red and crispy, been polishing it for a few hours.",
	  creation_date: "2023-03-23 10:12:21",
	  image_path: null,
	  category: "Food",
	  owner_id: "1"
      },

      {
	  id: "2",
	  name: "Badass sunglasses",
	  description: "'I'm here to kick ass and chew bubblegum and I'm all out of bubblegum.'",
	  creation_date: "2023-03-25 12:23:21",
	  image_path: null,
	  category: "Apparel",
	  owner_id: "1"
      },

	//--------------------LARS LISTINGS--------------------
      {
	  id: "3",
	  name: "Shoes",
	  description: "Nice pair of shoes. Worn 2 months. Great shape. Trust me bro. Please. I promise they're fine. You might not trust me because of my low rating but the people giving me low ratings were not serious actors.",
	  creation_date: "2022-11-12 23:23:11",
	  image_path: null,
	  category: "Apparel",
	  owner_id: "2"
      },

      {
	  id: "4",
	  name: "Handsome fedora",
	  description: "I used to wear this hat all the time while browsing /r/atheism but then I got married to a christian woman. You have to be an atheist to put an offer on this item.",
	  creation_date: "2023-01-22 09:11:23",
	  image_path: null,
	  category: "Apparel",
	  owner_id: "2"
      }
      
  ]);
};
