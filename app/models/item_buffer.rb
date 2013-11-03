class ItemBuffer < ActiveRecord::Base
	def self.bulk_update
		dbh = DatabaseRaw::connect
		dbh.execute 'BEGIN TRANSACTION'
		dbh.execute 'INSERT OR REPLACE INTO item_buffers (
				"id"
			  , "name"
			  , "rarity"
			  , "item_type"
			  , "crafting_discipline"
			  , "crafting_discipline_level"
			)
			SELECT items.id
				 , items.name
				 , rarities.name
				 , item_types.name
				 , disciplines.name
				 , recipes.discipline_level
				FROM
					(SELECT created_item_id AS item_id
						FROM recipes
					UNION
					SELECT recipe_item_id AS item_id
						FROM recipes
					) AS t
					LEFT OUTER JOIN items
						ON t.item_id = items.id
					LEFT OUTER JOIN rarities
						ON items.rarity_id = rarities.id
					LEFT OUTER JOIN item_types
						ON items.item_type_id = item_types.id
					LEFT OUTER JOIN recipes
						ON items.id = recipes.created_item_id
					LEFT OUTER JOIN disciplines
						ON recipes.discipline_id = disciplines.id
					ORDER BY items.name ASC
			'
		dbh.execute 'COMMIT TRANSACTION'
	end
end
