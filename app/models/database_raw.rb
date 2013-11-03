class DatabaseRaw
	def self.connect
		dbh = nil
		case ActiveRecord::Base.configurations[Rails.env]['adapter']
		when 'sqlite3'
			dbfile = 'db/gw2-ctp.db'
			dbh = SQLite3::Database.open dbfile
		else
			raise NotImplementedError
		end

		dbh.results_as_hash = true
		return dbh
	end
end
