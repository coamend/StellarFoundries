class CreateMoons < ActiveRecord::Migration
  def change
    create_table :moons do |t|
      t.string :name
      t.integer :planet_id
      t.float :average_orbit
      t.float :eccentricity
      t.float :mass
      t.float :radius
      t.float :density
      t.integer :planet_type_id

      t.timestamps null: false
    end
  end
end
