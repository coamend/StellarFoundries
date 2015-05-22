class CreateSubSectors < ActiveRecord::Migration
  def change
    create_table :sub_sectors do |t|
      t.integer :sector_id
      t.integer :subsector_X
      t.integer :subsector_Y

      t.timestamps null: false
    end
  end
end
