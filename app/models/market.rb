class Market < ActiveRecord::Base
	def self.bulk_update _d
		timestamp = Time.new.to_time.to_i
		dbh = DatabaseRaw::connect
		dbh.execute 'BEGIN TRANSACTION'
		x = dbh.prepare "INSERT INTO markets(
				'item_id'
			  , 'buy_count'
			  , 'buy_price'
			  , 'sell_count'
			  , 'sell_price'
			  , 'market_time'
			) VALUES (?,?,?,?,?, #{timestamp})"

		_d.each do |key, data|
			x.execute(key,
					  data[:buy_count],
					  data[:buy_price],
					  data[:sell_count],
					  data[:sell_price])
		end
		dbh.execute 'COMMIT TRANSACTION'
	end
end
