class CreateQuadrants < ActiveRecord::Migration
  def change
    create_table :quadrants do |t|
      t.integer :universe_id
      t.string :name
      t.integer :quadrant_x
      t.integer :quadrant_y

      t.timestamps null: false
    end
  end
end
