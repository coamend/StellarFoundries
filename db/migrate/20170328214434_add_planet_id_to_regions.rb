class AddPlanetIdToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :planet_id, :integer
  end
end
