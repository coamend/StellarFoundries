class AddPlanetIdToOres < ActiveRecord::Migration
  def change
    add_column :ores, :planet_id, :integer
  end
end
