class CreateCraftingProfits < ActiveRecord::Migration
  def change
    create_table :crafting_profits do |t|
      t.string     :name
      t.string     :crafting_discipline
      t.integer    :crafting_discipline_level
      t.integer    :sell_price
      t.integer    :sell_count
      t.integer    :buy_price
      t.integer    :buy_count
      t.integer    :crafting_cost
      t.integer    :crafting_profit_on_sell
      t.integer    :crafting_profit_on_buy
    end

    add_index :crafting_profits, 
              [:crafting_profit_on_sell, :crafting_cost],
              name: 'index_cp_profit_on_sell'
    add_index :crafting_profits, 
              [:crafting_profit_on_buy, :crafting_cost],
              name: 'index_cp_profit_on_buy'
    add_index :crafting_profits, 
              [:crafting_discipline, :crafting_discipline_level],
              name: 'index_cp_discipline'
  end
end
