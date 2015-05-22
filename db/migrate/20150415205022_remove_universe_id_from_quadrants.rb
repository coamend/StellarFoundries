class RemoveUniverseIdFromQuadrants < ActiveRecord::Migration
  def change
    remove_column :quadrants, :universe_id, :integer
    add_column :quadrants, :galaxy_id, :integer
  end
end
