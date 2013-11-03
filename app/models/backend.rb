class Backend
	def self.buffer_item_search
		ItemBuffer::bulk_update
	end

	def self.prefill_enumerations
		dbh = DatabaseRaw::connect
		dbh.execute 'BEGIN TRANSACTION'
		Discipline.prefill dbh
		ItemType.prefill dbh
		Rarity.prefill dbh
		dbh.execute 'COMMIT TRANSACTION'
	end

	def self.prepare_infrastructure
		self.scrap_recipe
		self.prefill_enumerations
		self.buffer_item_search
	end

	def self.scrap_market
		scrapper = Scrapper.new
		market = MarketWatcher.new(
			Recipe::get_all_craftables,
			scrapper.login_to(:gw2).scrap_data)

		Market::bulk_update market.price_data
		CraftingProfit::bulk_update
	end

	def self.scrap_recipe
		scrapper = Scrapper.new
		recipe = RecipeBuilder.new(
			scrapper.login_to(:gw2db).scrap_data(:gw2db_recipes),
			scrapper.login_to(:gw2db).scrap_data(:gw2db_items))

		Item::bulk_update recipe.items
		Recipe::bulk_update recipe.recipes
	end
end
