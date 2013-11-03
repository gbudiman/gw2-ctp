class Recipe < ActiveRecord::Base
	def self.bulk_update _d
		dbh = DatabaseRaw::connect
		dbh.execute 'BEGIN TRANSACTION'
		dbh.execute 'DELETE FROM recipes'
		x = dbh.prepare 'INSERT INTO recipes (
				"discipline_id"
			  , "discipline_level"
			  , "created_item_id"
			  , "created_item_amount"
			  , "recipe_required"
			  , "recipe_item_id"
			  , "recipe_amount"
			) VALUES (?,?,?,?,?,?,?)'

		_d.each do |e|
			x.execute(e[:discipline_id],
					  e[:discipline_level],
					  e[:created_item_id],
					  e[:created_item_amount],
					  e[:recipe_required],
					  e[:recipe_item_id],
					  e[:recipe_amount])
		end

		dbh.execute 'COMMIT TRANSACTION'
	end

	def self.get_all_craftables
		dbh = DatabaseRaw::connect
		dbh.execute '
			SELECT recipe_list.item_id
				, items.tp_id
				FROM
				(SELECT DISTINCT created_item_id AS item_id
					FROM recipes 
				UNION
				SELECT DISTINCT recipe_item_id AS item_id
					FROM recipes)
				AS recipe_list
				INNER JOIN items
					ON recipe_list.item_id = items.id
			'
	end
end
