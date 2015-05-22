class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.integer :system_id
      t.string :name
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
