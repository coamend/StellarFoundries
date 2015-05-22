class RemoveUniverseIdFromSectors < ActiveRecord::Migration
  def change
    remove_column :sectors, :universe_id, :integer
    add_column :sectors, :quadrant_id, :integer
  end
end
