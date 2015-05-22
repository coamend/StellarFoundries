class CreateGalaxies < ActiveRecord::Migration
  def change
    create_table :galaxies do |t|
      t.integer :turn_number
      t.integer :turn_frequency
      t.string :name
      t.datetime :last_turn_at

      t.timestamps null: false
    end
  end
end
