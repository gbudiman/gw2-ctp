class Discipline < ActiveRecord::Base
	def self.prefill _dbh
		x = _dbh.prepare "INSERT OR REPLACE INTO disciplines VALUES (?,?)"
		TextLoader::load_file(:discipline, false).each do |k, v|
			x.execute(k, v)
		end
	end
end
