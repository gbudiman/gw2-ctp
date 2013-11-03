class CraftingProfit < ActiveRecord::Base
	def self.bulk_update
		dbh = DatabaseRaw::connect
		dbh.execute 'BEGIN TRANSACTION'
		dbh.execute 'DELETE FROM crafting_profits'
		dbh.execute '
			INSERT OR REPLACE INTO crafting_profits (
					id
					, name
					, crafting_discipline
					, crafting_discipline_level
					, sell_price
					, sell_count
					, buy_price
					, buy_count
					, crafting_cost
					, crafting_profit_on_sell
					, crafting_profit_on_buy
				)
				SELECT crafting_tree.target_id AS target_id
					, target_item.name AS target_name
					, crafting_tree.discipline_name AS discipline_name
					, crafting_tree.discipline_level AS discipline_level
					, crafting_tree.target_sell_price AS target_sell_price
					, crafting_tree.target_sell_count AS target_sell_count
					, crafting_tree.target_buy_price AS target_buy_price
					, crafting_tree.target_buy_count AS target_buy_count
					, SUM(crafting_tree.crafting_cost) AS crafting_cost
					, CAST(crafting_tree.target_sell_price * 0.8 -
						SUM(crafting_tree.crafting_cost) AS integer)
						AS crafting_profit_on_sell
					, CAST(crafting_tree.target_buy_price * 0.8 -
						SUM(crafting_tree.crafting_cost) AS integer)
						AS crafting_profit_on_buy
					FROM
					(SELECT recipes.created_item_id AS target_id
						, recipes.recipe_amount * recipe_market.sell_price
							AS crafting_cost
						, disciplines.name AS discipline_name
						, recipes.discipline_level AS discipline_level
						, final_market.sell_price AS target_sell_price
						, final_market.sell_count AS target_sell_count
						, final_market.buy_price AS target_buy_price
						, final_market.buy_count AS target_buy_count
						FROM recipes
						INNER JOIN disciplines
							ON recipes.discipline_id = disciplines.id
						LEFT OUTER JOIN markets AS final_market
							ON final_market.item_id = recipes.created_item_id
								AND final_market.market_time =
									(SELECT MAX(market_time) from markets)
						LEFT OUTER JOIN markets AS recipe_market
							ON recipe_market.item_id = recipes.recipe_item_id
								AND recipe_market.market_time =
									(SELECT MAX(market_time) from markets)
					) AS crafting_tree
					INNER JOIN items AS target_item
						ON crafting_tree.target_id = target_item.id
					GROUP BY target_id
					ORDER BY target_buy_price - crafting_cost
		'
		dbh.execute 'COMMIT TRANSACTION'
	end
end
