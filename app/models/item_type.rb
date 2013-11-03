class ItemType < ActiveRecord::Base
	def self.prefill _dbh
		x = _dbh.prepare "INSERT OR REPLACE INTO item_types VALUES (?,?)"
		TextLoader::load_file(:item_type, false).each do |k, v|
			x.execute(k, v)
		end
	end
end
