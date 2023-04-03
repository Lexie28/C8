/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> } 
 */
exports.seed = async function(knex) {
  // Deletes ALL existing entries
  await knex('offer').del()
  await knex('offer').insert([
      {
	  id: 1,
	  accepted: false,
	  user_making_offer: 1,
	  user_receiving_offer: 2
      },
      {
	  id: 2,
	  accepted: true,
	  user_making_offer: 2,
	  user_receiving_offer: 1
      }
  ]);
};
