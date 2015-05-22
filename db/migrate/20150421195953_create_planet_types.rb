class CreatePlanetTypes < ActiveRecord::Migration
  def change
    create_table :planet_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
