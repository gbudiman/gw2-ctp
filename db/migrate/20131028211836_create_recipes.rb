class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer    :discipline_id
      t.integer    :discipline_level
      t.integer    :created_item_id
      t.integer    :created_item_amount
      t.integer    :recipe_item_id
      t.integer    :recipe_amount
      t.integer    :recipe_required
    end

    add_index :recipes, 
              [:discipline_id, :discipline_level],
              name: 'index_recipe_discipline'
    add_index :recipes, 
              [:created_item_id, :recipe_required],
              name: 'index_recipe_created_item'
    add_index :recipes, 
              [:recipe_item_id, :discipline_id, :discipline_level],
              name: 'index_recipe_recipe_item'
  end
end
