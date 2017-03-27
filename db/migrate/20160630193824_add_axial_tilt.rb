class AddAxialTilt < ActiveRecord::Migration
  def change
    add_column :planets, :axial_tilt, :integer
  end
end
