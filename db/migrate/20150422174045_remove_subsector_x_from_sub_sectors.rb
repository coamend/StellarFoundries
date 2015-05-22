class RemoveSubsectorXFromSubSectors < ActiveRecord::Migration
  def change
    remove_column :sub_sectors, :subsector_X, :integer
    remove_column :sub_sectors, :subsector_Y, :integer
    add_column :sub_sectors, :subsector_x, :integer
    add_column :sub_sectors, :subsector_y, :integer
  end
end
