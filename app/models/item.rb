class Item < ActiveRecord::Base
	def self.bulk_update _d
		dbh = DatabaseRaw::connect
		dbh.execute 'BEGIN TRANSACTION'

		x = dbh.prepare 'INSERT OR REPLACE INTO items (
				"id"
			  , "name"
			  , "item_type_id"
			  , "rarity_id"
			  , "description"
			  , "tp_id"
			) VALUES (?,?,?,?,?,?)'

		_d.each do |key, data|
			x.execute(key,
					  data[:name],
					  data[:item_type_id],
					  data[:rarity_id],
					  data[:description],
					  data[:tp_id])
		end

		dbh.execute 'COMMIT TRANSACTION'
	end
end
