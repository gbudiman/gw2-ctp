class TextLoader
	def self.load_file _f, _symbolic = true
		case _f
		when :discipline then f = 'lib/assets/discipline_lookup.txt'
		when :item_type then f = 'lib/assets/item_type_lookup.txt'
		when :rarity then f = 'lib/assets/rarity_lookup.txt'
		else f = _f
		end

		data = Hash.new
		File.open(f, 'r') do |infile|
			while line = infile.gets
				pair = line.split('#')[0].split(',')
				if _symbolic
					data[pair[0].to_sym] = pair[1].chomp 
				else
					data[pair[0].to_i] = pair[1].chomp
				end
			end
		end

		return data
	end
end
