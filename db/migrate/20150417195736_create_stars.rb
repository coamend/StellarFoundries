class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.string :name
      t.integer :system_id
      t.string :luminosity
      t.float :mass
      t.float :diameter
      t.float :surface_temperature

      t.timestamps null: false
    end
  end
end
