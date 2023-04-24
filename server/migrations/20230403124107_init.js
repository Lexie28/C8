/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
    return createUserTable()
	.then(createListingTable)
	.then(createOfferTable)
	.then(createOfferListingTable);


    function createUserTable() {
	return knex.schema
	    .createTable("user", (table) => {
		table.increments("id")
		    .primary();
		table.string("name")
		    .notNullable();
		table.integer("likes")
		    .defaultTo(0);
		table.integer("dislikes")
		    .defaultTo(0);
		table.string("profile_picture_path");
		table.string("phone_number", 12);
		table.string("email");
		table.string("location");
	    })
    }

    function createListingTable() {
	return knex.schema
	    .createTable("listing", (table) => {
		table.increments("id")
		    .primary();
		table.string("name")
		    .notNullable();
		table.string("description");
		table.datetime("creation_date");
		table.string("image_path");
		table.string("category");
		
		//FK
		table.integer("owner_id")
		    .unsigned() //Måste vara unsigned för att matcha user.id!
		    .notNullable()
		    .references("id")
		    .inTable("user")
		    .onDelete("CASCADE");
	    })
    }

    function createOfferTable() {
	return knex.schema
	    .createTable("offer", (table) => {
		table.increments("id").primary();
		table.boolean("accepted");		
		
		//FK
		table.integer("user_making_offer")
		    .unsigned()
		    .notNullable();
		table.integer("user_receiving_offer")
		    .unsigned()
		    .notNullable();
		table.foreign("user_making_offer", "user_receiving_offer")
		    .references("id")
		    .inTable("user")
		    .onDelete("CASCADE"); //Om en användare tas bort, ta bort offer också.		                          
	    })
    }

    function createOfferListingTable() {
	return knex.schema
	    .createTable("offer_listing", (table) => {
		//FK
		table.integer("offer_id")
		    .notNullable()
		    .unsigned()
		    .references("id")
		    .inTable("offer")
		    .onDelete("CASCADE");
		table.integer("listing_id")
		    .notNullable()
		    .unsigned()
		    .references("id")
		    .inTable("listing")
		    .onDelete("CASCADE");
	    });
    }
		
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
    return dropOfferListingTable()
	.then(dropListingTable)
	.then(dropOfferTable)
	.then(dropUserTable)
	.catch((err) => {
	    console.log(err);
	});
    
    function dropUserTable() {
	return knex.schema.dropTable("user");
    }
    function dropListingTable() {
	return knex.schema.dropTable("listing");
    }
    function dropOfferTable() {
	return knex.schema.dropTable("offer");
    }
    function dropOfferListingTable() {
	return knex.schema.dropTable("offer_listing");
    }

};
