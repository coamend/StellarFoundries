class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.integer :universe_id
      t.integer :sectorX
      t.integer :sectorY

      t.timestamps null: false
    end
  end
end
