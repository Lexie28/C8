/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> } 
 */
exports.seed = async function(knex) {
  // Deletes ALL existing entries
  await knex('offer').del()
  await knex('offer').insert([
      {
	  id: "1",
	  accepted: false,
	  user_making_offer: "1",
	  user_receiving_offer: "2",
	  creation_date: "2023-03-03 10:11:23"
	  
      },
      {
	  id: "2",
	  accepted: true,
	  user_making_offer: "2",
	  user_receiving_offer: "1",
	  creation_date: "2023-02-02 09:11:23"
      }
  ]);
};
