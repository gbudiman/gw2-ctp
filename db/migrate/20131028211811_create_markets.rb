class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.integer    :item_id
      t.integer    :market_time
      t.integer    :buy_count
      t.integer    :buy_price
      t.integer    :sell_count
      t.integer    :sell_price
    end

    add_index :markets, :market_time
    add_index :markets, [:item_id, :market_time]
  end
end
