class RemoveSectorXFromSectors < ActiveRecord::Migration
  def change
    remove_column :sectors, :sectorx, :integer
    remove_column :sectors, :sectory, :integer
    add_column :sectors, :sector_x, :integer
    add_column :sectors, :sector_y, :integer
  end
end
