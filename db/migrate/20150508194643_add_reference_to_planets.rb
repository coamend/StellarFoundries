class AddReferenceToPlanets < ActiveRecord::Migration
  def change
    remove_column :planets, :parent_planet_id
    add_reference :planets, :parent_planet, index: true
  end
end
