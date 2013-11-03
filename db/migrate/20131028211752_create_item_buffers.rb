class CreateItemBuffers < ActiveRecord::Migration
  def change
    create_table :item_buffers do |t|
      t.string     :name
      t.string     :rarity
      t.string     :item_type
      t.string     :crafting_discipline
      t.integer    :crafting_discipline_level
    end

    add_index :item_buffers, :name
  end
end
