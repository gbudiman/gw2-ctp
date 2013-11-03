class Rarity < ActiveRecord::Base
	def self.prefill _dbh
		x = _dbh.prepare "INSERT OR REPLACE INTO rarities VALUES (?,?)"
		TextLoader::load_file(:rarity, false).each do |k, v|
			x.execute(k, v)
		end
	end
end
