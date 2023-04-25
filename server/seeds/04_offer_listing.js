/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> } 
 */
exports.seed = async function(knex) {
  // Deletes ALL existing entries
  await knex('offer_listing').del()
  await knex('offer_listing').insert([
      {
	  offer_id: "1",
	  listing_id: "1"
      },
      {
	  offer_id: "1",
	  listing_id: "3"
      },
      {
	  offer_id: "2",
	  listing_id: "2"
      },
      {
	  offer_id: "2",
	  listing_id: "4"
      }
	  
  ]);
};
