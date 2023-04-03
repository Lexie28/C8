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
		table.integer("likes");
		table.integer("dislikes");
		table.string("profile_picture_path");
		table.string("phone_number");
		table.string("email");
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
		table.date("creation_date");
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
		table.boolean("accepted").notNullable();
		
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
    return dropUserTable()
	.then(dropListingTable())
	.then(dropOfferTable())
	.then(dropOfferListingTable());
    
    function dropUserTable() {
	return knex.schema.dropTable("user");
    }
    function dropListingTable() {
	return knex.schema.dropTable("table");
    }
    function dropOfferTable() {
	return knex.schema.dropTable("offer");
    }
    function dropOfferListingTable() {
	return kenx.schema.dropTable("offer_listing");
    }

};
