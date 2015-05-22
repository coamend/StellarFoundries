class AddSurfaceAreaToPlanets < ActiveRecord::Migration
  def change
    add_column :planets, :surface_area, :float
    add_column :moons, :surface_area, :float
  end
end
