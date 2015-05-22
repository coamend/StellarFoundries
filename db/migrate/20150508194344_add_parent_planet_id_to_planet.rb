class AddParentPlanetIdToPlanet < ActiveRecord::Migration
  def change
    add_column :planets, :parent_planet_id, :integer
  end
end
