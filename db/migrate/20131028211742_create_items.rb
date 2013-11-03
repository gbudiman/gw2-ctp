class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string     :name
      t.integer    :item_type_id
      t.integer    :rarity_id
      t.integer    :tp_id
      t.text       :description
    end

    add_index :items, :item_type_id
    add_index :items, :name
    add_index :items, :rarity_id
    add_index :items, :tp_id
  end
end
